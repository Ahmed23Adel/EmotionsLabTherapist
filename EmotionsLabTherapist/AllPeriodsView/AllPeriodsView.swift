import SwiftUI
import Charts

struct AllPeriodsView: View {
    @StateObject private var viewModel: AllPeriodsViewModel
    var patient: Patient
    
    init(patient: Patient) {
        self.patient = patient
        self._viewModel = StateObject(wrappedValue: AllPeriodsViewModel(patient: patient))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Emotion Recognition Progress")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            if viewModel.isLoading {
                ProgressView("Loading data...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Try Again") {
                        Task {
                            await viewModel.loadEmotionHistoryData()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.availableEmotions.isEmpty {
                // No data available
                VStack {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No emotion data available for this patient.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Emotion selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.availableEmotions, id: \.self) { emotion in
                            EmotionButton(
                                emotion: emotion,
                                isSelected: viewModel.selectedEmotion == emotion,
                                color: viewModel.colorForEmotion(emotion),
                                action: { viewModel.selectEmotion(emotion) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                // Chart
                if let selectedEmotion = viewModel.selectedEmotion {
                    VStack(alignment: .leading) {
                        Text("Error Count Trend: \(selectedEmotion.capitalized)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Chart Container
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            if viewModel.chartData.isEmpty {
                                Text("No data available for \(selectedEmotion)")
                                    .foregroundColor(.secondary)
                            } else {
                                chartView
                            }
                        }
                        .frame(height: 300)
                        .padding(.horizontal)
                        
                        // Legend and interpretation
                        HStack {
                            Circle()
                                .fill(viewModel.colorForEmotion(selectedEmotion))
                                .frame(width: 12, height: 12)
                            Text(selectedEmotion.capitalized)
                            
                            Spacer()
                            
                            Text("↓ Lower errors = Better recognition")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Progress summary
                        if let improvement = calculateImprovement() {
                            HStack {
                                Image(systemName: improvement >= 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                    .foregroundColor(improvement >= 0 ? .green : .red)
                                
                                Text("\(abs(improvement), specifier: "%.1f")% \(improvement >= 0 ? "improvement" : "decline") since first session")
                                    .font(.footnote)
                                    .foregroundColor(improvement >= 0 ? .green : .red)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 4)
                        }
                    }
                    
                    // Detailed sessions list
                    VStack(alignment: .leading) {
                        Text("Session Details")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        List {
                            ForEach(viewModel.chartData.sorted(by: { $0.date > $1.date })) { point in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(formatDate(point.date))
                                            .font(.subheadline)
                                        Text("Session #\(point.sessionIndex + 1)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("\(point.errorCount) errors")
                                            .font(.subheadline)
                                        
                                        if let previousPoint = getPreviousPoint(for: point) {
                                            let change = point.errorCount - previousPoint.errorCount
                                            let isImprovement = change < 0
                                            
                                            Text("\(isImprovement ? "↓" : "↑") \(abs(change))")
                                                .font(.caption)
                                                .foregroundColor(isImprovement ? .green : .red)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }
        .navigationTitle("Progress Overview")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadEmotionHistoryData()
            }
        }
    }
    
    @ViewBuilder
    private var chartView: some View {
        Chart {
            ForEach(viewModel.chartData.sorted(by: { $0.sessionIndex < $1.sessionIndex })) { point in
                LineMark(
                    x: .value("Session", point.sessionIndex + 1),
                    y: .value("Errors", point.errorCount)
                )
                .foregroundStyle(viewModel.colorForEmotion(viewModel.selectedEmotion ?? ""))
                
                PointMark(
                    x: .value("Session", point.sessionIndex + 1),
                    y: .value("Errors", point.errorCount)
                )
                .foregroundStyle(viewModel.colorForEmotion(viewModel.selectedEmotion ?? ""))
                
                if point.sessionIndex < viewModel.chartData.count - 1 {
                    AreaMark(
                        x: .value("Session", point.sessionIndex + 1),
                        y: .value("Errors", point.errorCount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                viewModel.colorForEmotion(viewModel.selectedEmotion ?? "").opacity(0.3),
                                viewModel.colorForEmotion(viewModel.selectedEmotion ?? "").opacity(0.1),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
    }
    
    private func getPreviousPoint(for point: EmotionTrendPoint) -> EmotionTrendPoint? {
        let sortedPoints = viewModel.chartData.sorted(by: { $0.sessionIndex < $1.sessionIndex })
        guard let currentIndex = sortedPoints.firstIndex(where: { $0.id == point.id }),
              currentIndex > 0 else {
            return nil
        }
        return sortedPoints[currentIndex - 1]
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func calculateImprovement() -> Double? {
        let sortedPoints = viewModel.chartData.sorted(by: { $0.sessionIndex < $1.sessionIndex })
        guard let firstPoint = sortedPoints.first,
              let lastPoint = sortedPoints.last,
              firstPoint.errorCount > 0 else {
            return nil
        }
        
        let change = Double(lastPoint.errorCount - firstPoint.errorCount)
        let percentChange = (change / Double(firstPoint.errorCount)) * 100.0
        return -percentChange // Negative percentage means improvement (fewer errors)
    }
}

struct EmotionButton: View {
    let emotion: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emotion.capitalized)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(color, lineWidth: 1)
                        )
                )
                .foregroundColor(isSelected ? .white : color)
        }
    }
}

struct AllPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllPeriodsView(patient: Patient())
        }
    }
}
