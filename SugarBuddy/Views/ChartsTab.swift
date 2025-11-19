//
//  ChartsTab.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct ChartsTab: View {
    @Environment(HealthKitService.self) private var healthKitService

    var body: some View {
        NavigationStack {
            GlucoseChartsGridView()
        }
    }
}

