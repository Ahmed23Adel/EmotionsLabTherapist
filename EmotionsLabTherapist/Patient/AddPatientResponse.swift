//
//  AddPatientResponse.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

struct AddPatientResponse: Decodable{
    let username: String
    let patient_id: String
    let therapist_id: String
    let coins: Int
    let created_at: String
    
}
