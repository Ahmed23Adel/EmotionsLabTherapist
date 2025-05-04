//
//  AllPeriodResponseModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//

import Foundation
import SwiftUI
struct EmotionHistoryResponse: Decodable {
    let patientId: String
    let sessionDates: [String]
    let emotionTrends: [String: [Int]]
    
    enum CodingKeys: String, CodingKey {
        case patientId = "patient_id"
        case sessionDates = "session_dates"
        case emotionTrends = "emotion_trends"
    }
}

// Helper model for chart data
struct EmotionTrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let errorCount: Int
    let sessionIndex: Int
}

struct EmotionTrendSeries {
    let name: String
    let color: Color
    let dataPoints: [EmotionTrendPoint]
}
