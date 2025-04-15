//
//  Session.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation

@MainActor
class Session {
    private(set) var date = Date()
    private(set) var period = Period()
    private(set) var patient = Patient()
    private(set) var gameType = GameType(gameTypeId: "", name: "", description: "")
    private(set) var supportedEmotions = ListOfEmotions()
    private let apiCaller = ApiCaller()
    init(date: Date){
        self.date = date
    }
    
    func setPeriod(period: Period) {
        self.period = period
    }
    
    func setPatient(patient: Patient) {
        self.patient = patient
    }
    
    func setGameType(gameType: GameType){
        self.gameType = gameType
    }
    
    func setDate(date: Date){
        self.date = date
    }
    
    func setSupportedEmotions(emotions: ListOfEmotions){
        self.supportedEmotions = emotions
    }
    

    func uploadData() async {
        do {
            // Missing return value for extractBody()
            guard let bodyData = extractBody() else {
                print("Failed to create request body")
                return
            }
            
            let data = try await apiCaller.callApiWithToken(
                endpoint: "sessions",
                method: .post,
                token: Therapist.shared.authAccess.accessTokenValue,
                body: bodyData
            )
            
            // Handle successful response
            print("Session uploaded successfully")
            // Add any processing of the response data here
            
        } catch {
            print("Error uploading session: \(error)")
            // Add appropriate error handling here
        }
    }
    
    func extractBody() -> [String: Any]? {
        // Need to return the body
        let isoFormatter = ISO8601DateFormatter()
        let formattedDate = isoFormatter.string(from: date)
        print("self.period.periodId,", self.period.periodId,)
        let body: [String: Any] = [
            "period_id": self.period.periodId,
            "patient_id": self.patient.patientId,
            "game_type_id": self.gameType.gameTypeId,
            "session_date": formattedDate,
            "emotions": supportedEmotions.extractEmotionAsList()
        ]
        return body
    }

}


