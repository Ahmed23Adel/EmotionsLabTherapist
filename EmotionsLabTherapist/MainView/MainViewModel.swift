//
//  MainViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject{
    @Published var isShowAddNewPatientSheet = false
    var newCreatedPatient:Patient = Patient()
    
    
    func showAddNewPatientSheet(){
        prepareBeforeNavigatingToAddNewPatient()
        self.isShowAddNewPatientSheet = true
    }
    
    func prepareBeforeNavigatingToAddNewPatient(){
        newCreatedPatient = Patient()
    }
    
}
