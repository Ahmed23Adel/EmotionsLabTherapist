//
//  PatientsErrors.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 11/04/2025.
//

import Foundation

enum PatientsErrors: Error{
    case empty
    case tooShort
    case invalidCharacters
    
    var errorDesc: String?{
        switch self {
        case .empty:
            return "Field can't be empty"
        case .tooShort:
            return "Field is too short"
        case .invalidCharacters:
            return "Field has invalid characters"
        }
    }
}
