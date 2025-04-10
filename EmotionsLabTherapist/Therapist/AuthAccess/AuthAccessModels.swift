//
//  AuthAccessModels.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation

struct TokenValidationResponse: Decodable {
    let valid: Bool
    let error: String?
}

struct RefreshTokenResponse: Decodable{
    let access_token: String
    let refresh_token: String
    let token_type: String
}

struct LoginUsingAppleResponse: Decodable{
    let access_token: String
    let refresh_token: String
    let token_type: String
}
 
