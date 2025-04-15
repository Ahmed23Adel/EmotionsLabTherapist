//
//  ListOfEmotions.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

class ListOfEmotions{
    private var emotions = [] as [SingleEmotion]
        
    init() {
        genTempDate()
    }
    
    func genTempDate() {
        let sm1 = SingleEmotion(emotionId: "6c912272-ca45-46d1-b55e-10caa05f13c1", name: "Happiness", description: "A feeling of joy, pleasure, or good fortune.")
        let sm2 = SingleEmotion(emotionId: "fb0a1988-3c27-4e67-92c0-8e1e06abd67a", name: "Sadness", description: "A feeling of sorrow or unhappiness.")
        let sm3 = SingleEmotion(emotionId: "50f09d69-f893-4963-bfd6-23bd10846e8c", name: "Anger", description: "A strong feeling of annoyance or hostility.")
        let sm4 = SingleEmotion(emotionId: "b1835295-9ea9-4eaa-a610-e48b2c50adf2", name: "Fear", description: "An emotion experienced in anticipation of danger.")
        let sm5 = SingleEmotion(emotionId: "418e4610-b5ed-4610-b220-f7427e8baf48", name: "Surprise", description: "A sudden feeling caused by something unexpected.")
        emotions.append(sm1)
        emotions.append(sm2)
        emotions.append(sm3)
        emotions.append(sm4)
        emotions.append(sm5)
    }
    
    // Add getter method for emotions
    func getEmotions() -> [SingleEmotion] {
        return emotions
    }
    
    func extractEmotionAsList() -> [String] {
        return emotions.map { $0.emotionId }
    }
}
