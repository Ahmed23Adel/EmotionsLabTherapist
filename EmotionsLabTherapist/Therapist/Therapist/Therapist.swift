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
    private let apiCaller = ApiCaller()
    
    private var therapistService = "therapist"
    private let fullNameAccount = "fullName"
    private let emailAccount = "email"
    private let appleIdAccount = "appleId"
    
    private init (){}
    
    private func loadTherapistData(){
        self.fullName = String(data: readKeychainForServiceAndAccount(therapistService, fullNameAccount), encoding: .utf8) ?? ""
        self.email = String(data: readKeychainForServiceAndAccount(therapistService, emailAccount), encoding: .utf8) ?? ""
        self.appleId = String(data: readKeychainForServiceAndAccount(therapistService, appleIdAccount), encoding: .utf8) ?? ""
    }
        
    func readKeychainForServiceAndAccount(_ service: String, _ account: String) -> Data {
        let output =  KeychainHelper.shared.read(service: Constants.KeyChainConstants.baseService + service, account: account)
        if let output = output{
            return output
        }
        return Data()
    }
    
    
    func signup(userID: String, fullName: String, email: String) async {
        do {
            let _ = try await apiCaller.callApiNoToken(endpoint: "therapists", method: .post, body: [
                "name": fullName,
                "email": email,
                "apple_id": userID
            ])
            
        } catch let error as ApiCallingErrorDetails {
            if error.statusCode == 400 {
            } else {
                print("An internal server error: \(error)")
            }
        } catch {
            fatalError("Unexpected error happened Code 01")
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
    
}
