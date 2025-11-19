//
//  DetailedChartView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct DetailedChartView: View {
    let chartItem: ChartItem
    
    var body: some View {
        VStack {
//            Text(chartItem.title ?? "")
//                .font(.title2)
//                .padding()
            
            switch chartItem.type {
            case .heatmap:
                DailyPatternHeatmap(readings: chartItem.data)
            default:
                Chart(chartItem.data) { record in
                    LineMark(
                        x: .value("Time", record.startDate),
                        y: .value("Glucose", record.value)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle(chartItem.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
