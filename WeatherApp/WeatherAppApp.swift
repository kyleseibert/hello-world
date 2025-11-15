import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
