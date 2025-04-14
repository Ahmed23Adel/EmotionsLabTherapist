//
//  ScheduleNewSessionsView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct ScheduleNewSessionsView: View {
    @State var period: Period
    @State var patient: Patient
    @StateObject var viewModel =  ScheduleNewSessionsViewModel()
    var body: some View {
        ZStack{
            CustomBackground()
            VStack{
                Text("Schedule sessions")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
            }
        }
        .onAppear{
            viewModel.setPeriod(period)
            viewModel.setPatient(patient)
        }
    }
}

#Preview {
    ScheduleNewSessionsView(period: Period(), patient: Patient())
}
