//
//  A1CStatusView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct A1CStatusView: View {
    let readings: [GlucoseRecord]
    
    // MARK: - Computed
    private var a1cValue: Double { readings.estimatedA1C() ?? 0 }
    private var status: A1CStatus { readings.a1cClassification() }
    private var trendChange: Double { readings.trendChange() }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [status.color.opacity(0.3), .black.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            if readings.isEmpty {
                ProgressView("Loading...")
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        A1CSummaryCard(a1cValue: a1cValue, status: status)
                        A1CTrendView(trendChange: trendChange)
                        A1CTrendChart(readings: readings.suffix(30)) // last 30 points
                    }
                    .padding()
                }
            }
        }
    }
}
