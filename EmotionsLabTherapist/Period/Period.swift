//
//  Period.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

class Period{
    private var startDate = Date()
    private var endDate = Date()
    
    init(){
    }
    
    func setStartDate(_ date: Date){
        self.startDate = date
    }
    
    func setEndDate(_ date: Date) throws{
        if date <= startDate {
            throw PeriodError.endDateEarlierThanStartDate
        }
    }
    
}
