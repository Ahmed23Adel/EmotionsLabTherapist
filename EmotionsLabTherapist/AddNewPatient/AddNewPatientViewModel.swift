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
    @Published var isSavigPatient = false
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func savePatient(){
        validateInputFields()
        if !isShowFirstNameError && !isShowLastNameError{
            
        }
    }
    private func validateInputFields(){
        validateFirstName()
        validateLastName()
    }
    
    private func validateFirstName(){
        validateName(nameSetter: patient.setFirstName,
                     name: firstName,
                     isShowError: &isShowFirstNameError,
                     errorMsg: &firstNameErrorMsg)
    }
    
    private func validateLastName(){
        validateName(nameSetter: patient.setLastName,
                     name: lastName,
                     isShowError: &isShowLastNameError,
                     errorMsg: &lastNameErrorMsg)
    }
    
    private func validateName(
        nameSetter: (String) throws -> Void,
        name: String,
        isShowError: inout Bool,
        errorMsg: inout String
    ){
        do{
            try nameSetter(name)
            isShowError = false
        } catch let error as PatientsErrors{
            isShowError = true
            if let desc = error.errorDesc{
                errorMsg = desc
            }
        } catch {
            
        }
    }
}

