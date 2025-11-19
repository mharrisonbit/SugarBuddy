//
//  A1CSummaryCard.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct A1CSummaryCard: View {
    let a1cValue: Double
    let status: A1CStatus

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: status.icon)
                .font(.system(size: 50))
                .foregroundStyle(status.color)

            Text("Estimated A1C")
                .font(.title2)
                .bold()

            Text("\(String(format: "%.2f", a1cValue))%")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(status.color)

            Text(status.rawValue)
                .font(.title3)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(status.color.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 6)
    }
}
