//
//  ScheduleNewPeriodViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation
import SwiftUI

@MainActor
class ScheduleNewPeriodViewModel: ObservableObject{
    private var patient = Patient()
    // Don't store a local copy, use a binding
    private var periodBinding: Binding<Period>?
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var isShowError = false
    @Published var errorTitle = ""
    @Published var errorMsg = ""
    
    @Published var selectedState: PeriodSessionHolderState = .selectingPeriod
    
    init(){
        
    }
    
    func setPatient(patient: Patient) {
        self.patient = patient
    }
    
    func setPeriod(periodBinding: Binding<Period>) {
        self.periodBinding = periodBinding
        // Set local working copies
        self.startDate = periodBinding.wrappedValue.startDate
        self.endDate = periodBinding.wrappedValue.endDate
    }
    
    func scheduleSessions() {
        guard let binding = periodBinding else { return }
        
        // Create a mutable copy
        var periodCopy = binding.wrappedValue
        
        // Update the copy
        periodCopy.setStartDate(startDate)
        do {
            try periodCopy.setEndDate(endDate)
            // Update the binding with the modified copy
            binding.wrappedValue = periodCopy
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
