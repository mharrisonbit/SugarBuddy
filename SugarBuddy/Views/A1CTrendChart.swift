//
//  A1CTrendChart.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct A1CTrendChart: View {
    let readings: [GlucoseRecord]

    var body: some View {
        VStack(alignment: .leading) {
            Text("A1C Trend (Estimated)")
                .font(.headline)
            
            Chart {
                ForEach(readings.sorted { $0.startDate < $1.startDate }) { r in
                    LineMark(
                        x: .value("Date", r.startDate),
                        y: .value("A1C", (r.value + 46.7) / 28.7)
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", r.startDate),
                        y: .value("A1C", (r.value + 46.7) / 28.7)
                    )
                }
            }
            .frame(height: 220)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 6)
        }
    }
}
