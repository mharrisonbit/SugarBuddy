//
//  MiniChartView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct MiniChartView: View {
    let readings: [GlucoseRecord]

    var body: some View {
        Chart(readings) { record in
            LineMark(
                x: .value("Time", record.startDate),
                y: .value("Glucose", record.value)
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .padding(.horizontal, 4)
    }
}

