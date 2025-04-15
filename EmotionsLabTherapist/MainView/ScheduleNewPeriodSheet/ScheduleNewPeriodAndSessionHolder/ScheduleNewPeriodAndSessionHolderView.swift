//
//  ScheduleNewPeriodAndSessionHolder.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct ScheduleNewPeriodAndSessionHolder: View {
    @StateObject var viewModel = ScheduleNewPeriodAndSessionHolderViewModel()
    @State var patient: Patient
    var body: some View {
        ZStack{
            if viewModel.currentState == .selectingPeriod{
                ScheduleNewPeriodView(
                    patient: viewModel.patient,
                    period: $viewModel.period, // Pass a binding instead of a value
                    parentSelectedState: $viewModel.currentState
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                ScheduleNewSessionsView(
                    period: viewModel.period,
                    patient: viewModel.patient)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentState)
        .onAppear{
            viewModel.patient = patient
        }
    }
}

#Preview {
    ScheduleNewPeriodAndSessionHolder(patient: Patient())
}
