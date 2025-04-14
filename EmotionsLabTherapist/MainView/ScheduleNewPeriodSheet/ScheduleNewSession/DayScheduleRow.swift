//
//  DayScheduleRow.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct DayScheduleRow: View {
    @Binding var daySchedule: DaySchedule
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(daySchedule.dayName)
                    .font(.headline)
                Text(daySchedule.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Stepper(value: $daySchedule.sessionsCount, in: 0...10) {
                Text("\(daySchedule.sessionsCount) session\(daySchedule.sessionsCount == 1 ? "" : "s")")
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    @State var dummy = DaySchedule(date: Date())
    DayScheduleRow(daySchedule: $dummy)
}
