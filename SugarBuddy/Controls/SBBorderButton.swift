//
//  SBButton.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/21/25.
//

import SwiftUI

struct SBBorderButton: View {
    let buttonText: String
    let image: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action ) {
            HStack{
                if !image.isNilOrWhitespace {
                    Image(systemName: image!)
                }
                Text(buttonText)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
