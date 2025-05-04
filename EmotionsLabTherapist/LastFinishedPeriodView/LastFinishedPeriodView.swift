//
//  LastFinishedPeriodView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//
//
//  LastFinishedPeriodView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 04/05/2025.
//

import SwiftUI

struct LastFinishedPeriodView: View {
    var patient: Patient
    @StateObject var viewModel = LastFinishedPeriodViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Period Results")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            if viewModel.isLoading {
                ZStack {
                    Color.clear
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.bottom, 10)
                        Text("Loading data...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if let timePeriod = viewModel.timePeriod {
                periodDataView(timePeriod)
            } else {
                noDataView
            }
        }
        .padding()
        .task {
            await viewModel.loadLatestPeriodData()
        }
        .onAppear {
            viewModel.setCurrentPatient(patient: patient)
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading data...")
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Text("Error")
                .font(.title)
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.loadLatestPeriodData()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var noDataView: some View {
        VStack {
            Spacer()
            Text("No period data available")
                .font(.title2)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func periodDataView(_ period: TimePeriod) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Period Info
            VStack(alignment: .leading, spacing: 5) {
                Text("Period: \(period.name)")
                    .font(.headline)
                Text(viewModel.formattedPeriodDates)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Sessions Selector
            Text("Sessions")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(period.sessions, id: \.sessionID) { session in
                        sessionButton(session)
                    }
                }
            }
            
            // Selected Session Details
            if let selectedSession = viewModel.selectedSession {
                sessionDetailsView(selectedSession)
            }
            
            Spacer()
        }
    }
    
    private func sessionButton(_ session: SessionLatest) -> some View {
        Button(action: {
            viewModel.selectSession(session)
        }) {
            VStack {
                Text(viewModel.formattedSessionDate(session.sessionDate))
                    .font(.subheadline)
                
                Text(session.status.rawValue.capitalized)
                    .font(.caption)
                    .padding(5)
                    .background(statusColor(session.status))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.selectedSession?.sessionID == session.sessionID ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.selectedSession?.sessionID == session.sessionID ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func sessionDetailsView(_ session: SessionLatest) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Session Details")
                    .font(.headline)
                Spacer()
                Text(session.status.rawValue.capitalized)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(session.status))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            if session.status == .finished, let gameResult = session.gameResult {
                gameResultView(gameResult)
            } else {
                Text("Session is not finished yet.")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func gameResultView(_ result: GameResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Completed at:")
                    .fontWeight(.medium)
                Spacer()
                Text(formattedDateTime(result.completedAt))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Time taken:")
                    .fontWeight(.medium)
                Spacer()
                Text("\(result.timeTaken) seconds")
                    .foregroundColor(.secondary)
            }
            
            Text("Emotion Results:")
                .fontWeight(.medium)
                .padding(.top, 5)
            
            if result.emotionsResults.isEmpty {
                Text("No emotion results recorded")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
            } else {
                VStack(spacing: 0) {
                    // Table Header
                    HStack {
                        Text("Emotion")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                        
                        Text("Errors")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(width: 80, alignment: .center)
                            .background(Color.blue.opacity(0.1))
                    }
                    
                    // Table Rows
                    ForEach(result.emotionsResults, id: \.emotionName) { emotionResult in
                        HStack {
                            Text(emotionResult.emotionName.capitalized)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.5))
                            
                            Text("\(emotionResult.errorCount)")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(width: 80, alignment: .center)
                                .background(Color.white.opacity(0.5))
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.2)),
                            alignment: .bottom
                        )
                    }
                }
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private func statusColor(_ status: SessionStatus) -> Color {
        switch status {
        case .scheduled:
            return Color.orange
        case .finished:
            return Color.green
        case .inProgress:
            return Color.blue
        case .cancelled:
            return Color.red
        }
    }
    
    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    LastFinishedPeriodView(patient: Patient())
}
