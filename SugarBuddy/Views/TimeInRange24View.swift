//
//  TimeInRange24View.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct TimeInRange24View: View {
    let summary: TimeInRangeSummary

    var body: some View {
        VStack(spacing: 16) {

            Text("Last 24 Hours")
                .font(.title2).bold()

            Chart {
                SectorMark(
                    angle: .value("Low", summary.lowPercent),
                    innerRadius: .ratio(0.55)
                )
                .foregroundStyle(.blue)

                SectorMark(
                    angle: .value("In Range", summary.inRangePercent),
                    innerRadius: .ratio(0.55)
                )
                .foregroundStyle(.green)

                SectorMark(
                    angle: .value("High", summary.highPercent),
                    innerRadius: .ratio(0.55)
                )
                .foregroundStyle(.red)
            }
            .frame(height: 200)

            HStack {
                legend("Low", value: summary.low, percent: summary.lowPercent, color: .blue)
                legend("In Range", value: summary.inRange, percent: summary.inRangePercent, color: .green)
                legend("High", value: summary.high, percent: summary.highPercent, color: .red)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }

    @ViewBuilder
    private func legend(_ title: String, value: Int, percent: Double, color: Color) -> some View {
        HStack {
            Circle().fill(color).frame(width: 10, height: 10)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption)
                Text("\(value) (\(Int(percent * 100))%)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
