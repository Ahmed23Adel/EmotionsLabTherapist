//
//  LatestTimePeridResponseModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//

import Foundation

struct PatientResponse: Decodable {
    let patientID: String
    let latestTimePeriod: TimePeriod
    
    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case latestTimePeriod = "latest_time_period"
    }
}

// MARK: - Time Period
struct TimePeriod: Decodable  {
    let periodID: String
    let name: String
    let startDate: Date
    let endDate: Date
    let createdAt: Date
    let sessions: [SessionLatest]
    
    enum CodingKeys: String, CodingKey {
        case periodID = "period_id"
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case createdAt = "created_at"
        case sessions
    }
}

// MARK: - Session
struct SessionLatest: Decodable  {
    let sessionID: String
    let gameTypeID: String
    let sessionDate: Date
    let coinsReward: Int
    let status: SessionStatus
    let createdAt: Date
    let emotions: [Emotion]
    let gameResult: GameResult?
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case gameTypeID = "game_type_id"
        case sessionDate = "session_date"
        case coinsReward = "coins_reward"
        case status
        case createdAt = "created_at"
        case emotions
        case gameResult = "game_result"
    }
}

// MARK: - Emotion
struct Emotion: Decodable  {
    let emotionID: String
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case emotionID = "emotion_id"
        case name
        case description
    }
}

// MARK: - Game Result
struct GameResult: Decodable  {
    let resultID: String
    let completedAt: Date
    let timeTaken: Int
    let emotionsResults: [EmotionResult]
    
    enum CodingKeys: String, CodingKey {
        case resultID = "result_id"
        case completedAt = "completed_at"
        case timeTaken = "time_taken"
        case emotionsResults = "emotions_results"
    }
}

// MARK: - Emotion Result
struct EmotionResult: Decodable  {
    let emotionName: String
    let errorCount: Int
    
    enum CodingKeys: String, CodingKey {
        case emotionName = "emotion_name"
        case errorCount = "error_count"
    }
}

// MARK: - Session Status Enum
enum SessionStatus: String, Codable {
    case scheduled = "scheduled"
    case finished = "finished"
    case inProgress = "in_progress"
    case cancelled = "cancelled"
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let iso8601NoMilliseconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

// MARK: - Decoder Configuration
extension JSONDecoder {
    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try parsing with milliseconds first
            if let date = DateFormatter.iso8601Full.date(from: dateString) {
                return date
            }
            
            // Then try without milliseconds
            if let date = DateFormatter.iso8601NoMilliseconds.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }
}

// MARK: - Usage Example
extension PatientResponse {
    static func decode(from jsonData: Data) throws -> PatientResponse {
        return try JSONDecoder.apiDecoder.decode(PatientResponse.self, from: jsonData)
    }
}
