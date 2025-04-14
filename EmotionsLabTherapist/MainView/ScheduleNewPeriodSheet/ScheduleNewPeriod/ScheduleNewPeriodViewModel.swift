//
//  ScheduleNewPeriodViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation
@MainActor
class ScheduleNewPeriodViewModel: ObservableObject{
    private var patient = Patient()
    private var period = Period()
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var isShowError = false
    @Published var errorTitle = ""
    @Published var errorMsg = ""
    
    @Published var selectedState: PeriodSessionHolderState = .selectingPeriod
    
    init(){
        
    }
    
    func setPatient(patient: Patient){
        self.patient = patient
    }
    
    func scheduleSessions(){
        period.setStartDate(startDate)
        do{
            try period.setEndDate(endDate)
        } catch {
            isShowError = true
            errorTitle = "error with end date"
            errorMsg = "end date must be greater than start date"
        }
        
    }
    
    func moveToNextState(){
        selectedState = .selectingSessions
    }
}
