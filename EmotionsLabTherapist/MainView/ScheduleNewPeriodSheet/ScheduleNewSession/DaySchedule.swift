//
//  DaySchedule.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

struct DaySchedule: Identifiable {
    let id = UUID()
    let date: Date
    let dayName: String
    let formattedDate: String
    var sessionsCount: Int = 0
    
    init(date: Date) {
        self.date = date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        self.dayName = formatter.string(from: date)
        
        formatter.dateFormat = "MMM d, yyyy"
        self.formattedDate = formatter.string(from: date)
    }
}

