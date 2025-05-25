//
//  Patient.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

@MainActor
class Patient: ObservableObject, Identifiable, Hashable, Equatable{
    nonisolated let id = UUID()
    
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var username: String = ""
    private(set) var patientId: String = ""
    private(set) var coins: Int = 0
    private(set) var hasUnfinishedSessionYesterday: Bool = false
    
    private let MIN_NAME_LENGTH = 2
    private let apiCaller = ApiCaller()
    init(){
        
    }
    
    static func == (lhs: Patient, rhs: Patient) -> Bool {
        return lhs.patientId == rhs.patientId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(patientId)
    }
    
    func setUsername(_ username: String){
        self.username = username
    }
    
    func setPatientId(_ patientId: String){
        self.patientId = patientId
    }
    
    func setFirstName(_ name: String) throws {
        try validateName(name)
        self.firstName = name
        
    }
    
    func setLastName(_ name: String) throws {
        try validateName(name)
        self.lastName = name
        
    }
    
    func setHasUnfinishedSessionYesterday(hasUnfinishedSessionYesterday: Bool){
        self.hasUnfinishedSessionYesterday = hasUnfinishedSessionYesterday
    }
    
    
    private func validateName(_ name: String) throws{
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty else{
            throw PatientsErrors.empty
        }
        
        guard name.count >= MIN_NAME_LENGTH else{
            throw PatientsErrors.tooShort
        }
        
        let regex = "^[A-Za-z]+$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmedName)
        guard isValid else{
            throw PatientsErrors.invalidCharacters
        }
    }
    
    
    func uploadData(token: String, therapistId: String, funcShowError: ()-> Void, funcSucceed: (String)-> Void) async {
        do {
            
            let data = try await apiCaller.callApiWithToken(endpoint: "patients",
                                       method: .post,
                                       token: token,
                                       body: [
                                        "therapist_id": therapistId,
                                        "first_name": firstName,
                                        "last_name": lastName
                                       ]
            )

            let decoder = JSONDecoder()
            let response = try decoder.decode(AddPatientResponse.self, from: data)
            self.username = response.username
            funcSucceed(response.username)
        } catch {
            print("error", error, "token", token)
            funcShowError()
        }
        
    }
    
    
    
    
}
