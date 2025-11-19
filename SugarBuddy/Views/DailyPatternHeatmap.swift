//
//  DailyPatternHeatmap.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct DailyPatternHeatmap: View {
    let readings: [GlucoseRecord]
    
    var body: some View {
        let hourly = readings.hourlyAverages()
        let days = Array(Set(hourly.map { $0.day })).sorted()
        
        VStack(alignment: .leading) {
//            Text("Daily Patterns (24h)")
//                .font(.headline)
//                .padding(.bottom, 4)
            
            Chart(hourly, id: \.id) { item in
                RectangleMark(
                    x: .value("Hour", item.hour),
                    y: .value("Day", item.day),
                    width: .ratio(1),
                    height: .ratio(1)
                )
                .foregroundStyle(colorForGlucose(item.average))
            }
            .chartXAxis {
                AxisMarks(values: Array(0...23)) { value in
                    AxisValueLabel {
                        Text("\(value.as(Int.self) ?? 0)h")
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: days) { value in
                    AxisValueLabel {
                        if let day = value.as(Date.self) {
                            Text(day, format: .dateTime.weekday(.short))
                        }
                    }
                }
            }
            .frame(height: CGFloat(days.count * 20))
            .cornerRadius(8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private func colorForGlucose(_ value: Double) -> Color {
        switch value {
        case ..<70: return .blue.opacity(0.7)       // low
        case 70..<180: return .green.opacity(0.7)   // in range
        default: return .red.opacity(0.7)           // high
        }
    }
}

//extension Array where Element == GlucoseRecord {
//    func hourlyAverages() -> [HourlyAverage] {
//        let grouped = Dictionary(grouping: self) { record -> (Date, Int) in
//            let day = Calendar.current.startOfDay(for: record.startDate)
//            let hour = Calendar.current.component(.hour, from: record.startDate)
//            return (day, hour)
//        }
//
//        return grouped.map { key, records in
//            let avg = records.map { $0.value }.reduce(0, +) / Double(records.count)
//            return HourlyAverage(day: key.0, hour: key.1, average: avg)
//        }
//        .sorted { $0.day < $1.day || ($0.day == $1.day && $0.hour < $1.hour) }
//    }
//}

//struct HourlyAverage: Identifiable {
//    var id: String { "\(day.timeIntervalSinceReferenceDate)-\(hour)" }
//    let day: Date
//    let hour: Int
//    let average: Double
//}
