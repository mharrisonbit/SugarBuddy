//
//  SugarBuddyApp.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/15/25.
//

import SwiftUI

@main
struct SugarBuddyApp: App {
    @State private var healthKitService: HealthKitService = HealthKitService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(healthKitService)
            
        }
    }
}
