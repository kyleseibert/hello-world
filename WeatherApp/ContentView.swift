import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @State private var city: String = "San Francisco"

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("Enter a city", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 16)
                    .onSubmit {
                        viewModel.fetchWeather(for: city)
                    }

                Button(action: {
                    viewModel.fetchWeather(for: city)
                }) {
                    Label("Get Weather", systemImage: "cloud.sun.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                WeatherSummaryView(state: viewModel.state)

                Spacer()
            }
            .padding()
            .navigationTitle("Weather Buddy")
            .task {
                if viewModel.state == .idle {
                    viewModel.fetchWeather(for: city)
                }
            }
        }
    }
}

struct WeatherSummaryView: View {
    let state: WeatherViewModel.State

    var body: some View {
        switch state {
        case .idle:
            return AnyView(Text("Type a city to get started.")
                .font(.headline)
                .foregroundColor(.secondary))
        case .loading:
            return AnyView(ProgressView("Fetching weather...")
                .progressViewStyle(CircularProgressViewStyle()))
        case .failed(let message):
            return AnyView(Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center))
        case .loaded(let report):
            return AnyView(VStack(spacing: 12) {
                Text(report.city)
                    .font(.title)
                    .bold()
                Text(report.summary)
                    .font(.title2)
                HStack {
                    WeatherMetricView(title: "Temp", value: "\(report.temperature, specifier: "%.1f")°C")
                    WeatherMetricView(title: "Feels", value: "\(report.apparentTemperature, specifier: "%.1f")°C")
                }
                HStack {
                    WeatherMetricView(title: "Wind", value: "\(report.windSpeed, specifier: "%.1f") km/h")
                    WeatherMetricView(title: "Humidity", value: "\(report.humidity, specifier: "%.0f")%")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16)))
        }
    }
}

struct WeatherMetricView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}
