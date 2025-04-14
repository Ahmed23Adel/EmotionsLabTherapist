//
//  ScheduleNewPeriodView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct ScheduleNewPeriodView: View {
    @StateObject private var viewModel = ScheduleNewPeriodViewModel()
    var patient: Patient
    var period: Period
    @Binding var parentSelectedState: PeriodSessionHolderState
    var body: some View {
        ZStack{
            CustomBackground()
            
            VStack {
                Text("Schedule a new period")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                
                HStack{
                    DatePickerView(nameOfDate: "Start Date", dateValue: $viewModel.startDate)
                    DatePickerView(nameOfDate: "End Date", dateValue: $viewModel.endDate)


                }
                
                Button("Next"){
                    viewModel.scheduleSessions()
                    if !viewModel.isShowError{
                        parentSelectedState = .selectingSessions
                    }
                    
                }
            }
            
            
            
            
        }
        .onAppear{
            viewModel.setPatient(patient: patient)
        }
        .alert(isPresented: $viewModel.isShowError){
            Alert(title: Text(viewModel.errorTitle),
                  message: Text(viewModel.errorMsg),
                  dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    
}


struct DatePickerView: View {
    let nameOfDate: String
    @Binding var dateValue: Date

    var body: some View {
        VStack(alignment: .leading) {
            Text(nameOfDate)
                .font(.headline)
                .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))

            DatePicker(
                "",
                selection: $dateValue,
                displayedComponents: [.date]
            )
            .labelsHidden()
            .padding(.vertical)
        }
    }
}


#Preview {
    ScheduleNewPeriodView(patient: Patient(), period: Period(), parentSelectedState: .constant(.selectingPeriod))
}
