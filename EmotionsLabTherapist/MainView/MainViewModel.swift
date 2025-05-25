//
//  MainViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject{
    @Published var isShowAddNewPatientSheet = false
    @Published var listOfPatients = [] as [Patient]
    @Published var selectedPatient: Patient?
    var newCreatedPatient:Patient = Patient()
    private let apiCaller = ApiCaller()
    private let therapistOwner = Therapist.shared
    @Published var isLoadingAllPatients = false
    
    @Published var isShowSchedulePeriodSheet: Bool = false
    
    init (){
        Task{
            await downloadAllPatientsBasicInfo()
        }
        
    }
    func showAddNewPatientSheet(){
        prepareBeforeNavigatingToAddNewPatient()
        self.isShowAddNewPatientSheet = true
    }
    
    func prepareBeforeNavigatingToAddNewPatient(){
        newCreatedPatient = Patient()
    }
    
    func downloadAllPatientsBasicInfo() async{
        isLoadingAllPatients = true
        do{
            let data = try await apiCaller.callApiWithToken(
                endpoint: "therapists/patients",
                method: .get,
                token: therapistOwner.authAccess.accessTokenValue)
            let decoder = JSONDecoder()
            let patients = try decoder.decode([PatientBasicInfo].self, from: data)
            parsePatientsBasicInfo(patients: patients)
        } catch{
            
        }
    }
    
    private func parsePatientsBasicInfo(patients: [PatientBasicInfo]){
        for patientInfo in patients{
            do{
                let patient = Patient()
                try patient.setFirstName(patientInfo.firstName)
                try patient.setLastName(patientInfo.lastName)
                patient.setUsername(patientInfo.username)
                patient.setPatientId(patientInfo.patientId)
                patient.setHasUnfinishedSessionYesterday(hasUnfinishedSessionYesterday: patientInfo.hasUnfinishedSessionYesterday)
                listOfPatients.append(patient)
            } catch {
                
            }
            
        }
        isLoadingAllPatients = false
    }
    
    func showSchedulePeriod(){
        self.isShowSchedulePeriodSheet = true
    }
    
    func appendPatient(patient: Patient){
        print("appendPatient")
        listOfPatients.append(patient)
    }
}
