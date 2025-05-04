//
//  AllPeriodsViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//

import Foundation
import SwiftUI
import Combine

class AllPeriodsViewModel: ObservableObject {
    // API results
    @Published var sessionDates: [String] = []
    @Published var emotionTrends: [String: [Int]] = [:]
    
    // UI state
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var selectedEmotion: String? = nil
    @Published var availableEmotions: [String] = []
    
    // Formatted data for charts
    @Published var chartData: [EmotionTrendPoint] = []
    
    // Colors for different emotions
    let emotionColors: [String: Color] = [
        "happy": .green,
        "sad": .blue,
        "angry": .red,
        "fearful": .purple,
        "surprised": .orange,
        "disgusted": .brown,
        // Add more emotions and colors as needed
    ]
    
    private let apiCaller =  ApiCaller()
    private var patient: Patient
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func loadEmotionHistoryData() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let data = try await apiCaller.callApiWithToken(
                endpoint: "patient-emotion-history",
                method: .get,
                token: Therapist.shared.authAccess.accessTokenValue,
                params: [
                    "patient_id": patient.patientId
                ]
            )
            
            await parseResponse(data: data)
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load data: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    private func parseResponse(data: Data) async {
        do {
            let decoder = JSONDecoder.apiDecoder
            let response = try decoder.decode(EmotionHistoryResponse.self, from: data)
            
            await MainActor.run {
                self.sessionDates = response.sessionDates
                self.emotionTrends = response.emotionTrends
                self.availableEmotions = Array(response.emotionTrends.keys).sorted()
                
                // Auto-select the first emotion if available
                if let firstEmotion = self.availableEmotions.first {
                    self.selectedEmotion = firstEmotion
                    self.updateChartData(for: firstEmotion)
                }
                
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to parse data: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func selectEmotion(_ emotion: String) {
        selectedEmotion = emotion
        updateChartData(for: emotion)
    }
    
    private func updateChartData(for emotion: String) {
        guard let emotionData = emotionTrends[emotion] else {
            chartData = []
            return
        }
        
        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Map the emotion data to chart points
        chartData = zip(sessionDates, emotionData).enumerated().compactMap { index, element in
            let (dateString, errorCount) = element
            if let date = dateFormatter.date(from: dateString) {
                return EmotionTrendPoint(date: date, errorCount: errorCount, sessionIndex: index)
            }
            return nil
        }
    }
    
    func colorForEmotion(_ emotion: String) -> Color {
        return emotionColors[emotion.lowercased()] ?? .gray
    }
}
