//
//  ScheduleNewSessionsViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

@MainActor
class ScheduleNewSessionsViewModel: ObservableObject{
    @Published var patient = Patient()
    @Published var period = Period()
    
    
    func setPatient(_ patient: Patient){
        self.patient = patient
    }
    
    func setPeriod(_ period: Period){
        self.period = period
    }
    
}
