//
//  SBGlassButton.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/21/25.
//

import SwiftUI

struct SBGlassButton: View {
    let buttonText: String
    let image: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action ) {
            HStack{
                if !image.isNilOrWhitespace {
                    Image(systemName: image!)
                }
                Text(buttonText)
                    .foregroundColor(Color.black)
            }
        }
        .buttonStyle(GlassProminentButtonStyle())
        .tint(Color.clear)
    }
}
