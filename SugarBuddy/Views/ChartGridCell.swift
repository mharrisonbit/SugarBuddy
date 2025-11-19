//
//  ChartGridCell.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI
import Charts

struct ChartGridCell: View {
    let item: ChartItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
                .padding(.bottom, 4)

            MiniChartView(readings: item.data)
                .frame(height: 150)
                .cornerRadius(8)
                .shadow(radius: 2)
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

