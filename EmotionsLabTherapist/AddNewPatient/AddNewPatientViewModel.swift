//
//  AddNewPatientViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

@MainActor
class AddNewPatientViewModel: ObservableObject{
    var patient: Patient
    @Published var firstName:  String = ""
    @Published var lastName:  String = ""
    @Published var isShowFirstNameError = false
    @Published var isShowLastNameError = false
    @Published var firstNameErrorMsg = ""
    @Published var lastNameErrorMsg = ""
    @Published var isSavigPatient = false
    private let therapistOwner = Therapist.shared
    
    @Published var isShowAlertFailAddPatient =  false
    @Published var alertFailAddPatientErrorMsg =  ""
    @Published var alertFailAddPatientErrorTitle =  ""
    
    
    @Published var isPatientAlreadySaved = false
    @Published var newPatientUsername = ""
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func savePatient(){
        validateInputFields()
        if !isShowFirstNameError && !isShowLastNameError{
            isSavigPatient = true
            Task{
                await patient.uploadData(
                    token: therapistOwner.authAccess.accessTokenValue,
                    therapistId: therapistOwner.therapistID,
                    funcShowError: showErrorForNotAddingPatient,
                    funcSucceed: showSuccessForAddingNewPatient
                )
                
                
            }
            
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
    
    private func showErrorForNotAddingPatient(){
        DispatchQueue.main.async {
            self.isSavigPatient = false
            self.isShowAlertFailAddPatient = true
            self.alertFailAddPatientErrorMsg = "please try again later"
            self.alertFailAddPatientErrorTitle = "Faild to add new patient"
        }
        
        
    }
    
    private func showSuccessForAddingNewPatient(username: String){
        print("showSuccessForAddingNewPatient", username)
        DispatchQueue.main.async {
            self.isSavigPatient = false
            self.isPatientAlreadySaved = true
            self.newPatientUsername = username
        }
    }
    
    private func funcStopShowingProgress(){
        isSavigPatient = false
    }
}

