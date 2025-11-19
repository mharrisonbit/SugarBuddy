import SwiftUI
import Charts

struct GlucoseChartsGridView: View {
    
    @Environment(HealthKitService.self) private var healthKitService
    
    @State private var selectedRange = "30 Days"
    private let options = ["30 Days", "60 Days", "90 Days"]
//    private let readings: [GlucoseRecord]
    
    private var chartItems: [ChartItem] {
        [
            ChartItem(title: "Glucose Over Time", data: healthKitService.readings, type: .line),
            ChartItem(title: "Daily Average", data: aggregateDaily(healthKitService.readings), type: .mini),
            ChartItem(title: "Trend", data: healthKitService.readings, type: .line),
            ChartItem(title: "High/Low Zones", data: healthKitService.readings, type: .mini),
            ChartItem(title: "Daily Patterns (24h)", data: healthKitService.readings, type: .heatmap)
        ]
    }
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    // Picker for date range
                    HStack {
                        Picker("Select Range", selection: $selectedRange) {
                            ForEach(options, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedRange) { _, newValue in
                            Task {
                                await healthKitService.getReadings(range: newValue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .buttonStyle(.borderedProminent)
                    
                    // Estimated A1C
                    if let a1c = healthKitService.readings.estimatedA1C() {
                        HStack {
                            Text("Estimated A1C:")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.1f %%", a1c))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Grid of charts
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(chartItems) { item in
                            ChartItemView(item: item)
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - ProgressView Overlay
            if healthKitService.isLoading {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                ProgressView("Loading Charts...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 6)
            }
        }
    }
    
    private func aggregateDaily(_ readings: [GlucoseRecord]) -> [GlucoseRecord] {
        let grouped = Dictionary(grouping: readings) { record in
            Calendar.current.startOfDay(for: record.startDate)
        }
        
        return grouped.map { day, records in
            let avg = records.map { $0.value }.reduce(0, +) / Double(records.count)
            return GlucoseRecord(
                id: UUID().uuidString,
                value: avg,
                unit: "mg/dL",
                deviceModel: nil,
                osVersion: nil,
                deviceName: nil,
                syncIdentifier: nil,
                syncVersion: nil,
                timezone: nil,
                status: nil,
                trendArrow: nil,
                trendRate: nil,
                transmitterTime: nil,
                startDate: day,
                endDate: day,
                rawMetadata: nil
            )
        }.sorted { $0.startDate < $1.startDate }
    }
}
