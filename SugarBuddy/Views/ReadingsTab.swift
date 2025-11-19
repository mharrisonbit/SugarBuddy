//
//  ReadingsTab.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

// ReadingsTab.swift
import SwiftUI
import Combine

struct ReadingsTab: View {
    @Environment(HealthKitService.self) private var healthKitService
    @State private var selectedHours = 12
    private let hourOptions = [2, 6, 12]

    // Timer publisher for auto-refresh every 5 minutes
    private let refreshTimer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack {
                // Loading indicator
                if healthKitService.isLoading {
                    ProgressView("Loading readings...")
                        .scaleEffect(1.5)
                        .padding()
                }

                // Time in Range last 24 hours
                if !healthKitService.readings.isEmpty {
                    let last24hReadings = healthKitService.readings.filter {
                        $0.startDate >= Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
                    }
                    let tir = last24hReadings.timeInRangeLast24Hours()
                    TimeInRange24View(summary: tir)
                        .padding(.vertical)
                }

                // Hour selection above chart
                Picker("Hours", selection: $selectedHours) {
                    ForEach(hourOptions, id: \.self) { Text("\($0)H") }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Hourly chart using selectedHours
                if !healthKitService.readings.isEmpty {
                    let filteredReadings = healthKitService.readings.filter {
                        $0.startDate >= Calendar.current.date(byAdding: .hour, value: -selectedHours, to: Date())!
                    }
                    HourlyGlucoseChart(readings: filteredReadings)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .onAppear {
                Task {
                    if healthKitService.readings.isEmpty {
                        await healthKitService.getReadings(range: "30 Days")
                    }
                }
            }
            .onReceive(refreshTimer) { _ in
                Task {
                    await healthKitService.getReadings(range: "30 Days")
                }
            }
        }
    }
}
