//
//  ChartItemView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct ChartItemView: View {
    let item: ChartItem
    
    var body: some View {
        NavigationLink {
            DetailedChartView(chartItem: item)
        } label: {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                    .padding(.bottom, 4)
                
                switch item.type {
                case .heatmap:
                    DailyPatternHeatmap(readings: item.data)
                        .frame(height: 150)
                default:
                    MiniChartView(readings: item.data)
                        .frame(height: 150)
                }
            }
            .padding(4)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
}

