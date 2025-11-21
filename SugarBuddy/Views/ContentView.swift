import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ReadingsTab()
                .tabItem { Label("Readings", systemImage: "list.bullet") }

            ChartsTab()
                .tabItem { Label("Chart", systemImage: "chart.line.uptrend.xyaxis") }
            
            SettingsTabView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }

    }
}
