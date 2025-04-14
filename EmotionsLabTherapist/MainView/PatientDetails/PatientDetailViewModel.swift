//
//  PatientDetailViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

@MainActor
class PatientDetailViewModel: ObservableObject{
    @Published var patient = Patient()
    
    init(){
        
    }
    
    func setPatient(patient: Patient){
        self.patient = patient
    }
    
}
