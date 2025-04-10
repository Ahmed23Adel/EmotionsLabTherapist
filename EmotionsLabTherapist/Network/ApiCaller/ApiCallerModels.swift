//
//  ApiCallerModels.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation

struct ApiCallingErrorDetails: Error{
    let statusCode: Int
    let message: String
}
