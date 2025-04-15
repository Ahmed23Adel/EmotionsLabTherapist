//
//  AddPeriodResponse.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

struct AddPeriodResponse: Codable{
    
    let name: String
    let startDate: String
    let endDate: String
    let periodID: String
    let therapistId: String
    let createdAt: String
    
    
    enum CodingKeys: String, CodingKey{
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case periodID = "period_id"
        case therapistId = "therapist_id"
        case createdAt = "created_at"
    }
}
