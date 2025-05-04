//
//  Therapist.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation

class Therapist: ObservableObject{
    static let shared  = Therapist()
    let authAccess = AuthAccess.shared
    private(set) var fullName: String = ""
    private(set) var email: String = ""
    private(set) var appleId: String = ""
    private(set) var therapistID: String = ""
    private let apiCaller = ApiCaller()
    
    private var therapistService = "therapist"
    private let fullNameAccount = "fullName"
    private let emailAccount = "email"
    private let appleIdAccount = "appleId"
    private let therapistIdAccount = "therapistId"
    
    private init (){
    }
    
    func loadTherapistData(){
        self.fullName = String(data: readKeychainForServiceAndAccount(therapistService, fullNameAccount), encoding: .utf8) ?? ""
        self.email = String(data: readKeychainForServiceAndAccount(therapistService, emailAccount), encoding: .utf8) ?? ""
        self.appleId = String(data: readKeychainForServiceAndAccount(therapistService, appleIdAccount), encoding: .utf8) ?? ""
        self.therapistID = String(data: readKeychainForServiceAndAccount(therapistService, therapistIdAccount), encoding: .utf8) ?? ""
        print("fullName", fullName)
        print("email", email)
        print("appleId", appleId)
        print("therapistID", therapistID)
        
    }
        
    func readKeychainForServiceAndAccount(_ service: String, _ account: String) -> Data {
        let output =  KeychainHelper.shared.read(service: Constants.KeyChainConstants.baseService + service, account: account)
        if let output = output{
            return output
        }
        return Data()
    }
    
    
    func signupAndExtractTherapistId(appleId: String, fullName: String, email: String) async -> String{
        do {
            let response = try await apiCaller.callApiNoToken(endpoint: "therapists", method: .post, body: [
                "name": fullName,
                "email": email,
                "apple_id": appleId
            ])
            return try parseSignupReseponse(response: response)
            
        } catch {
            print("error in signup")
        }
        return ""
    }

    private func parseSignupReseponse(response: Data) throws -> String{
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(SignUpResponse.self, from: response)
            return response.therapist_id
        } catch{
            throw ApiCallerErrors.serializationError
        }
    }
    
    
    private func saveAppleIdInUserDefaults(name: String, email: String, appleId: String){
        if let nameData = name.data(using: .utf8), let emailData = email.data(using: .utf8), let appleIdData = appleId.data(using: .utf8){
            KeychainHelper.shared.save(nameData,
                                       service: Constants.KeyChainConstants.baseService + therapistService,
                                       account: fullNameAccount)
            KeychainHelper.shared.save(emailData,
                                       service: Constants.KeyChainConstants.baseService + therapistService,
                                       account: emailAccount)
            KeychainHelper.shared.save(appleIdData,
                                       service: Constants.KeyChainConstants.baseService + therapistService,
                                       account: appleIdAccount)
            
        }
        
    }
    
    
    func tryReadAppleId() -> (Bool, String?) {
        loadTherapistData()
        if appleIdAccount != "" {
            return (true,appleIdAccount)
        } else {
            return (false, nil)
        }
    }
    
    func saveTherapistId(therapistId: String){
        let serviceName = Constants.KeyChainConstants.baseService + therapistService
        KeychainHelper.shared.save(therapistId.data(using: .utf8) ?? Data(), service: serviceName, account: therapistIdAccount)
    }
}
