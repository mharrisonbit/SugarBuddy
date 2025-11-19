import SwiftUI

struct ContentView: View {
    @Environment(HealthKitService.self) private var healthKitService
//    @State private var selectedRange = "30 Days"
//    private let options = ["30 Days", "60 Days", "90 Days"]

    var body: some View {
        TabView {
            ReadingsTab()
                .tabItem { Label("Readings", systemImage: "list.bullet") }

            ChartsTab()
                .tabItem { Label("Chart", systemImage: "chart.line.uptrend.xyaxis") }
        }
//        .task {
//            await healthKitService.getReadings(range: selectedRange)
//        }
    }
}
