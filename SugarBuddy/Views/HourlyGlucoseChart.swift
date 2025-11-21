//
//  HourlyGlucoseChart.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

// HourlyGlucoseChart.swift
import SwiftUI
import Charts

struct HourlyGlucoseChart: View {
    let readings: [GlucoseRecord]
    
    var body: some View {
        let minDate = readings.map { $0.startDate }.min() ?? Date()
        
        VStack(alignment: .leading, spacing: 12) {
//            Text("Glucose")
            Text("Avg: \(String(format: "%.0f", readings.map({ $0.value }).average ?? 0)) mg/dL")
                .font(.headline)

            if readings.isEmpty {
                Text("No readings available.")
                    .foregroundStyle(.secondary)
                    .padding(.top)
            } else {
                Chart {
                    ForEach(readings) { record in
                        LineMark(
                            x: .value("Time", record.startDate),
                            y: .value("BG", record.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .lineStyle(.init(lineWidth: 2))

                        PointMark(
                            x: .value("Time", record.startDate),
                            y: .value("BG", record.value)
                        )
                        .symbolSize(35)
                    }

                    // Average line
                    if let avg = readings.map({ $0.value }).average {
                        RuleMark(y: .value("Avg", avg))
                            .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [6,6]))
                            .foregroundStyle(.blue.opacity(0.5))
//                            .annotation(position: .topTrailing) {
//                                Text("Avg: \(String(format: "%.0f", avg))")
//                                    .font(.caption2)
//                                    .foregroundColor(.blue)
//                            }
                    }
                }
                .chartXScale(domain: minDate ... Date.now)
                .frame(height: 250)
                .padding(.top, 4)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, style: .time)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
