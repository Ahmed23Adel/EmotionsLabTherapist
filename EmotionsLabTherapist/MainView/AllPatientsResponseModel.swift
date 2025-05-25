//
//  AllPatientsResponseModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

struct PatientBasicInfo: Codable {
    let username: String
    let patientId: String
    let therapistId: String
    let coins: Int
    let createdAt: String
    let firstName: String
    let lastName: String
    let hasUnfinishedSessionYesterday: Bool

    enum CodingKeys: String, CodingKey {
        case username
        case patientId = "patient_id"
        case therapistId = "therapist_id"
        case coins
        case createdAt = "created_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case hasUnfinishedSessionYesterday = "has_unfinished_session_yesterday"
    }
}
