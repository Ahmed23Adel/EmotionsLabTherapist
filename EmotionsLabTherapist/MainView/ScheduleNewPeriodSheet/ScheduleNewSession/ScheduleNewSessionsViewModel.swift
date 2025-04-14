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
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var daySchedules: [DaySchedule] = []
    
    var formattedStartDate: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: period.startDate)
    }
    
    var formattedEndDate: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: period.endDate)
    }
    
    
    func setPatient(_ patient: Patient){
        self.patient = patient
    }
    
    func setPeriod(_ period: Period){
        self.period = period
        self.startDate = self.period.startDate
        self.endDate = self.period.endDate
    }
    
    
    func generateDaySchedules() {
        daySchedules = []
        let startDate = period.startDate
        let endDate = period.endDate
        
        let calendar = Calendar.current
        guard let dayRange = calendar.dateComponents([.day], from: startDate, to: endDate).day else {
            return
        }
        for dayOffset in 0...dayRange {
            guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else {
                continue
            }
            let daySchedule = DaySchedule(date: currentDate)
            daySchedules.append(daySchedule)
        }
    }
    
    func saveSesssions(){
        
    }
    
}
