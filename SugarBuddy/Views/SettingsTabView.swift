//
//  SettingsTabView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/20/25.
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        VStack{
            Text("this is the settings page and will allow the user to set settings")
            HStack{

                SBGlassButton(buttonText: "Save") {
                    print("Hello from the glass button")
                }
                .disabled(false)
            }
        }
    }
}
