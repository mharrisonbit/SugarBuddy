//
//  ChartModel.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

enum ChartType {
    case line, mini, heatmap
}

struct ChartItem: Identifiable {
    let id = UUID()
    let title: String
    let data: [GlucoseRecord]
    let type: ChartType
}

