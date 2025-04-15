//
//  GameType.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

class GameType{
    private(set) var gameTypeId: String
    private(set) var name: String
    private(set) var description: String
    
    init(gameTypeId: String, name: String, description: String) {
        self.gameTypeId = gameTypeId
        self.name = name
        self.description = description
    }
}
