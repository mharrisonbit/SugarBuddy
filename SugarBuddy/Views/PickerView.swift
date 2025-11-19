//
//  PickerView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct PickerView: View {
    @Binding var selectedRange: String
    let options: [String]
    let action: () -> Void

    var body: some View {
        Picker("Select Range", selection: $selectedRange) {
            ForEach(options, id: \.self) { Text($0) }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedRange) { _, _ in action() }
    }
}
