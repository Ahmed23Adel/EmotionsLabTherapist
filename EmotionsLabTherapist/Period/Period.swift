//
//  Period.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import Foundation



class Period {
    var startDate: Date = Date()
    var endDate: Date = Date()
    private var apiCaller = ApiCaller()
    private(set) var periodId = ""
    
    func setStartDate(_ date: Date) {
        startDate = date
    }
    
    func setEndDate(_ date: Date) throws {
        // Make sure to validate before setting
        if date >= startDate {
            endDate = date
        } else {
            throw PeriodError.endDateEarlierThanStartDate
        }
    }
    
    func uploadPeriod(patient: Patient) async{
        do {
            let therapist = Therapist.shared
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            let data = try await apiCaller.callApiWithToken(
                endpoint: "time-periods",
                method: .post,
                token: therapist.authAccess.accessTokenValue,
                body: [
                    "patient_id": patient.patientId,
                    "name": "fixed name",
                    "start_date": formatter.string(from: startDate),
                    "end_date": formatter.string(from: endDate)
                ])
            
            let decoder = JSONDecoder()
            let periodResponse = try decoder.decode(AddPeriodResponse.self, from: data)
            self.periodId = periodResponse.periodID
            print("periodResponse.periodID", periodResponse.periodID)
            print("self.periodId", self.periodId)
            
        } catch {
            print("period error", error)
        }
                
    }
    
    func setPeriodId(_ periodId: String){
        self.periodId = periodId
    }
}


