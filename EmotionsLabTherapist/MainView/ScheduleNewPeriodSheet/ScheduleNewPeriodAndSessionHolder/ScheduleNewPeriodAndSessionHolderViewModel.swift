//
//  ScheduleNewPeriodAndSessionHolderViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

enum PeriodSessionHolderState {
    case selectingPeriod
    case selectingSessions
}

@MainActor
class ScheduleNewPeriodAndSessionHolderViewModel: ObservableObject{
    @Published var patient = Patient()
    @Published var period = Period()
    
    @Published var currentState: PeriodSessionHolderState = .selectingPeriod
    
    
    
    func setPatient(patient: Patient) {
        self.patient = patient
    }
    
   
    
}
