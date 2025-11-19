//
//  GlucoseRecordRow.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct GlucoseRecordRow: View {
    let record: GlucoseRecord

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(String(format: "%.0f", record.value)) \(record.unit)")
                    .font(.headline)

                Spacer()

                Text(record.startDate.formatted(date: .abbreviated, time: .shortened))
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            if let device = record.deviceModel {
                Text("Device: \(device)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
