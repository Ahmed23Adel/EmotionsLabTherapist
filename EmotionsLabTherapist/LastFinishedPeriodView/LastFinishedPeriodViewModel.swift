//
//  LastFinishedPeriodViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//

import SwiftUI

@MainActor
class LastFinishedPeriodViewModel: ObservableObject {
    @Published var currentPatient = Patient()
    @Published var timePeriod: TimePeriod?
    @Published var selectedSession: SessionLatest?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiCaller = ApiCaller()
    
    func setCurrentPatient(patient: Patient) {
        self.currentPatient = patient
    }
    
    func loadLatestPeriodData() async {
        print("h1")
        isLoading = true
        errorMessage = nil
        
        do {
            let data = try await apiCaller.callApiWithToken(
                endpoint: "latest-time-period",
                method: .get,
                token: Therapist.shared.authAccess.accessTokenValue,
                params: [
                    "patient_id": currentPatient.patientId
                ]
            )
            print("h2", data)
            parseResponse(data: data)
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func parseResponse(data: Data) {
        do {
            print("h3")
            let decoder = JSONDecoder.apiDecoder
            let response = try decoder.decode(PatientResponse.self, from: data)
            print("found", response.latestTimePeriod.name)
            self.timePeriod = response.latestTimePeriod
            
            // Auto-select the first session if available
            if let firstSession = timePeriod?.sessions.first {
                self.selectedSession = firstSession
            }
        } catch {
            errorMessage = "Failed to parse data: \(error.localizedDescription)"
        }
    }
    
    func selectSession(_ session: SessionLatest) {
        self.selectedSession = session
    }
    
    var formattedPeriodDates: String {
        guard let period = timePeriod else { return "No period data" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let startDate = dateFormatter.string(from: period.startDate)
        let endDate = dateFormatter.string(from: period.endDate)
        
        return "\(startDate) - \(endDate)"
    }
    
    func formattedSessionDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
