//
//  AddNewPatientViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

class AddNewPatientViewModel: ObservableObject{
    var patient: Patient
    @Published var firstName:  String = ""
    @Published var lastName:  String = ""
    @Published var isShowFirstNameError = false
    @Published var isShowLastNameError = false
    @Published var firstNameErrorMsg = ""
    @Published var lastNameErrorMsg = ""
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func savePatient(){
        
    }
}

