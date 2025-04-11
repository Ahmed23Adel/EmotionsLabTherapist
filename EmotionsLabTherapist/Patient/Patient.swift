//
//  Patient.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

class Patient: ObservableObject{
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    
    private let MIN_NAME_LENGTH = 2
    
    init(){
        
    }
    
    func setFirstName(_ name: String) throws {
        try validateName(name)
        self.firstName = name
        
    }
    
    func setLastName(_ name: String) throws {
        try validateName(name)
        self.lastName = name
        
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
    
    
    
    
}
