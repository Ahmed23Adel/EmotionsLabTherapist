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
    
    func tryReadAccessTokenFromKeyChainAndValidate() async -> Bool{
        let tokenFound = tryReadTokenFromKeyChainAndValidate(
           account: accessTokenAccount,
           setTokenValue: { self.accessTokenValue = $0 },
           setIsStored: { self.isAccessTokenStored = $0 },
           
        )
        if tokenFound{
            self.isAccessTokenValid = await validateAccessToken()
            return self.isAccessTokenValid
            
        }
        return false
    }

    func tryReadRefreshTokenFromKeyChainAndValidate() -> Bool {
       tryReadTokenFromKeyChainAndValidate(
           account: refreshTokenAccount,
           setTokenValue: { self.refreshTokenValue = $0 },
           setIsStored: { self.isRefreshTokenStored = $0 },
           
       )
        return self.isRefreshTokenStored
    }

    private func tryReadTokenFromKeyChainAndValidate(
       account: String,
       setTokenValue: (String) -> Void,
       setIsStored: (Bool) -> Void,
       ) -> Bool{
           
       if let tokenData = readFromKeychain(account: account),
          let token = String(data: tokenData, encoding: .utf8) {
           print("token ", token)
           setTokenValue(token)
           setIsStored(true)
           return true
       } else {
           setIsStored(false)
           return false
       }
    }

    
    private func readFromKeychain(account: String) -> Data? {
        return KeychainHelper.shared.read(service: serviceName, account: account)
    }
    
    private func validateAccessToken() async -> Bool{
        return await validateToken(token: accessTokenValue, token_type: accessTokenAccount)
//
    }
    
    private func validateRefreshToken() async -> Bool {
        return await validateToken(token: refreshTokenValue, token_type: refreshTokenAccount)
    }
    
    private func validateToken(token: String, token_type: String) async -> Bool {
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
            return response.valid
        } catch {
            return false
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
    
    
    
    
    
    func loginUsingAppleAuth(appleId: String) async -> Bool{
        do {
            let data = try await apiCaller.callApiNoToken(endpoint: "auth/apple", method: .post, params: [
                "apple_id": appleId
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
