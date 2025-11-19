//
//  EstimatedA1CView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/18/25.
//

import SwiftUI

struct EstimatedA1CView: View {
    let a1c: Double?

    var body: some View {
        if let a1c = a1c {
            HStack {
                Text("Estimated A1C:")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.1f %%", a1c))
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)
        }
    }
}
