//
//  Period.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation


struct Period {
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    mutating func setStartDate(_ date: Date) {
        startDate = date
    }
    
    mutating func setEndDate(_ date: Date) throws {
        // Make sure to validate before setting
        if date >= startDate {
            endDate = date
        } else {
            throw PeriodError.endDateEarlierThanStartDate
        }
    }
}


