//
//  A1CTrendView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct A1CTrendView: View {
    let trendChange: Double

    var body: some View {
        VStack(spacing: 8) {
            Text("A1C Trend")
                .font(.headline)
            
            if trendChange > 0.1 {
                Label("Your A1C is trending **up** by \(String(format: "%.2f", trendChange))%", systemImage: "arrow.up.circle.fill")
                    .foregroundColor(.red)
            } else if trendChange < -0.1 {
                Label("Your A1C is trending **down** by \(String(format: "%.2f", abs(trendChange)))%", systemImage: "arrow.down.circle.fill")
                    .foregroundColor(.green)
            } else {
                Label("Your A1C is **stable**", systemImage: "minus.circle.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 6)
    }
}
