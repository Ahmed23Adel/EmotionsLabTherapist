//
//  AuthAccess.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation

class AuthAccess: ObservableObject{
    static let shared = AuthAccess()
    
    private(set) var accessTokenValue: String = ""
    private(set) var refreshTokenValue: String = ""
    @Published private(set) var isAccessTokenStored: Bool = false
    @Published private(set) var isRefreshTokenStored: Bool = false
    @Published public var isAccessTokenValid: Bool = false
    @Published public var isRefreshTokenValid: Bool = false
    var isTokenValid: Bool {
        isAccessTokenValid && isRefreshTokenValid
    }
    var isTokenStored: Bool {
        isAccessTokenStored && isRefreshTokenStored
    }
    let accessTokenAccount = "accesstoken"
    let refreshTokenAccount = "refreshtoken"
    let apiCaller = ApiCaller()
    let serviceName: String = Constants.KeyChainConstants.baseService + "AuthorizationAccessToken"
    
    private init(){}
    
    func tryReadAccessTokenFromKeyChainAndValidate() -> Bool{
       tryReadTokenFromKeyChainAndValidate(
           account: accessTokenAccount,
           setTokenValue: { self.accessTokenValue = $0 },
           setIsStored: { self.isAccessTokenStored = $0 },
           validate: { self.validateAccessToken() }
       )
        return self.isAccessTokenStored
    }

    func tryReadRefreshTokenFromKeyChainAndValidate() -> Bool {
       tryReadTokenFromKeyChainAndValidate(
           account: refreshTokenAccount,
           setTokenValue: { self.refreshTokenValue = $0 },
           setIsStored: { self.isRefreshTokenStored = $0 },
           validate: { self.validateRefreshToken() }
       )
        return self.isRefreshTokenStored
    }

    private func tryReadTokenFromKeyChainAndValidate(
       account: String,
       setTokenValue: (String) -> Void,
       setIsStored: (Bool) -> Void,
       validate: () -> Void) {
           
       if let tokenData = readFromKeychain(account: account),
          let token = String(data: tokenData, encoding: .utf8) {
           setTokenValue(token)
           setIsStored(true)
           validate()
       } else {
           setIsStored(false)
       }
    }

    
    private func readFromKeychain(account: String) -> Data? {
        return KeychainHelper.shared.read(service: serviceName, account: account)
    }
    
    private func validateAccessToken() {
        validateToken(token: accessTokenValue, token_type: accessTokenAccount){ isValid in
            self.isAccessTokenValid = isValid
        }
    }
    
    private func validateRefreshToken() {
        validateToken(token: refreshTokenValue, token_type: refreshTokenAccount){ isValid in
            self.isRefreshTokenValid = isValid
        }
    }
    
    private func validateToken(token: String, token_type: String, completion: @escaping (Bool) -> Void){
        // Task let this block of code run in the background as not to block the UI
        Task {
            do {
                let data = try await apiCaller.callApiNoToken(
                    endpoint: "validate-token",
                    method: .post,
                    body: [
                        "token": token,
                        "token_type": token_type
                    ]
                )
                let decoder = JSONDecoder()
                let response = try decoder.decode(TokenValidationResponse.self, from: data)
                completion(response.valid)
            } catch {
                completion(false)
            }
        }
    }
    
    
    func refreshToken() async -> Bool{
        do{
            let data = try await apiCaller.callApiNoToken(endpoint: "refresh-token", method: .post, body: [
                "refresh_token": refreshTokenValue
            ])
            let decoder = JSONDecoder()
            let response = try decoder.decode(RefreshTokenResponse.self, from: data)
            parseRefresh(response: response)
            return true
        } catch let error as ApiCallingErrorDetails{
            if error.statusCode == 401{
                print("Refresh token is expired")
                cleanOldToken()
                return false
            }
        } catch {
        }
        return false
    }
    
    private func parseRefresh(response: RefreshTokenResponse){
        accessTokenValue = response.access_token
        refreshTokenValue = response.refresh_token
        saveAccessAndRefreshValues()
        setAccessAndRefreshReadValid()
    }
    
    private func cleanOldToken(){
        KeychainHelper.shared.clearAll()
        accessTokenValue = ""
        refreshTokenValue = ""
        isAccessTokenStored = false
        isRefreshTokenStored = false
        isAccessTokenValid = false
        isRefreshTokenValid = false
    }
    
    
    
    
    
    func loginUsingAppleAuth(userID: String) async -> Bool{
        do {
            let data = try await apiCaller.callApiNoToken(endpoint: "auth/apple", method: .post, params: [
                "apple_id": userID
            ])
            let decoder = JSONDecoder()
            let response = try decoder.decode(LoginUsingAppleResponse.self, from: data)
            accessTokenValue = response.access_token
            refreshTokenValue = response.refresh_token
            setAccessAndRefreshReadValid()
            saveAccessAndRefreshValues()
            print("saved")
            return true
        } catch {
            return false
        }
    }

    private func saveAccessAndRefreshValues(){
        if let accessTokenData = accessTokenValue.data(using: .utf8),
           let refreshTokenData = refreshTokenValue.data(using: .utf8) {
            
            KeychainHelper.shared.save(accessTokenData, service: serviceName, account: accessTokenAccount)
            KeychainHelper.shared.save(refreshTokenData, service: serviceName, account: refreshTokenAccount)
        }
    }
    
    private func setAccessAndRefreshReadValid(){
        isAccessTokenStored = true
        isRefreshTokenStored = true
        isAccessTokenValid = true
        isRefreshTokenValid = true
    }
    
}
