//
//  A1CSummaryView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct A1CSummaryView: View {
    let a1cValue: Double
    let status: A1CStatus
    let sevenDayAvg: Double
    let readings: [GlucoseRecord]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: status.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(status.color)

                VStack(alignment: .leading) {
                    Text("Estimated A1C: \(String(format: "%.2f", a1cValue))%")
                        .font(.headline)
                    Text(status.rawValue)
                        .foregroundStyle(status.color)
                }

                Spacer()
            }

            Text("7-Day Average: \(String(format: "%.0f", sevenDayAvg)) mg/dL")
                .font(.subheadline)
                .foregroundColor(.secondary)

            NavigationLink {
                A1CStatusView(readings: readings)
            } label: {
                Text("View A1C Details")
                    .font(.body)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(12)
            }
            .padding(.top, 6)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 6)
    }
}
