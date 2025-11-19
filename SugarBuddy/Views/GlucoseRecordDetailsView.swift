//
//  GlucoseRecordDetailsView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/16/25.
//

import SwiftUI

struct GlucoseRecordDetailsView: View {
    let record: GlucoseRecord
    
    var body: some View {
        List {
            Section("General") {
                recordRow("ID", record.id)
                recordRow("Value", "\(record.value) \(record.unit)")
                recordRow("Start Date", record.startDate.formatted(date: .abbreviated, time: .shortened))
                recordRow("End Date", record.endDate.formatted(date: .abbreviated, time: .shortened))
            }
            if(record.deviceModel != nil){
                Section("Device") {
                    recordRow("Device Model", record.deviceModel)
                    recordRow("OS Version", record.osVersion)
                    recordRow("Device Name", record.deviceName)
                }
            }
            
            if(record.syncIdentifier != nil){
                Section("Metadata") {
                    recordRow("Sync Identifier", record.syncIdentifier)
                    recordRow("Sync Version", record.syncVersion)
                    recordRow("Time Zone", record.timezone)
                    recordRow("Status", record.status)
                    recordRow("Trend Arrow", record.trendArrow)
                    recordRow("Trend Rate", record.trendRate)
                    recordRow("Transmitter Time", record.transmitterTime)
                }
            }
            // Raw metadata
            if let metadata = record.rawMetadata, !metadata.isEmpty {
                Section("Raw Metadata") {
                    ForEach(metadata.keys.sorted(), id: \.self) { key in
                        recordRow(key, "\(metadata[key]?.value ?? "")")
                    }
                }
            }
        }
        .navigationTitle("Glucose Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func recordRow(_ title: String, _ value: Any?) -> some View {
        if let value = value {
            HStack {
                Text(title)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(describing: value))
                    .fontWeight(.medium)
            }
        }
    }
}
