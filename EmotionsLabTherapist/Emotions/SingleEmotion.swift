//
//  SingleEmotion.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

class SingleEmotion{
    private(set) var emotionId: String
    private(set) var name: String
    private(set) var description: String
    
    init(emotionId: String, name: String, description: String) {
        self.emotionId = emotionId
        self.name = name
        self.description = description
    }
}
