//
//  DaySchedule.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

@MainActor
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
    
    func extractSessionObjects(period: Period, patient: Patient) -> [Session]{
        var sessions = Array<Session>()
        for i in 0..<sessionsCount{
            let session = Session(date: date)
            session.setPeriod(period: period)
            session.setPatient(patient: patient)
            let fixedGameType = GameType(gameTypeId: "8e59a9d9-8729-41a2-9e3d-eb7c64b2bcaa", name: "fixedName", description: "fixedDesc")
            session.setGameType(gameType: fixedGameType)
            session.setDate(date: date)
            sessions.append(session)
        }
        
        
        return sessions
    }
}

