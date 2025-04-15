//
//  ScheduleNewSessionsView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct ScheduleNewSessionsView: View {
    var period: Period
    var patient: Patient
    @StateObject var viewModel =  ScheduleNewSessionsViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            CustomBackground()
            VStack{
                if viewModel.isSavingPeriodAndSessions{
                    ProgressView("Please wait")
                } else{
                    Text("Schedule sessions")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                   
                    HStack {
                        Text("Start Date \(viewModel.formattedStartDate)")
                            .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                            .padding()
                        
                        Text("End Date \(viewModel.formattedEndDate)")
                            .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                            .padding()
                    }
                    .padding()
                    
                    VStack {
                        List {
                            ForEach(viewModel.daySchedules.indices, id: \.self) { index in
                                DayScheduleRow(daySchedule: $viewModel.daySchedules[index])
                                    .listRowBackground(Color.clear)
                                
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .scrollContentBackground(.hidden)
                        .background(
                            Color.white.opacity(0.2)
                                .blur(radius: 25)
                        )
                        .cornerRadius(10)
                        .frame(maxHeight: .infinity)
                        
                        Button("Save"){
                            Task{
                                await viewModel.saveSesssions()
                                dismiss()
                            }
                            
                            
                        }
                        .padding()
                    }
                }
                
            }
            
        }
        .onAppear{
            viewModel.setPeriod(period)
            viewModel.setPatient(patient)
            viewModel.generateDaySchedules()
        }
    }
}

#Preview {
    ScheduleNewSessionsView(period: Period(), patient: Patient())
}
