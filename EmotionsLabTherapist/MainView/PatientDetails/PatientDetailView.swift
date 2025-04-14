//
//  PatientDetailView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: Patient
    @StateObject var viewModel = PatientDetailViewModel()

    var body: some View {
        ZStack{
            Color(red: 245/255, green: 238/255, blue: 220/255)
                            .ignoresSafeArea()
            HStack {
                Text("Name:")
                    .fontWeight(.semibold)
                Text("\(patient.firstName) \(patient.lastName)")
            }
        }.onAppear{
            viewModel.setPatient(patient: patient)
        }
    }
    
}

#Preview {
    PatientDetailView(patient: Patient())
}
