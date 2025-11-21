//
//  SettingsTabView.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/20/25.
//

import SwiftUI

struct SettingsTabView: View {
    
    @State private var isOn: Bool = false
    
    var body: some View {
        VStack{
            Text("this is the settings page and will allow the user to set settings")
            HStack{
                Toggle("Enable Feature", isOn: $isOn)
                    .onChange(of: isOn) {_, value in }
            }
            
            SBGlassButton(buttonText: "Save") {
                    saveData()
                }
                .disabled(false)
        }.padding(.horizontal)
    }
    
    private func saveData() {
        print(isOn)
    }
}
