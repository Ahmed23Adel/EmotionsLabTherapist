//
//  TherapistModels.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

struct SignUpResponse: Decodable{
    let name: String
    let email: String
    let apple_id: String
    let therapist_id: String
    let created_at: String
}
