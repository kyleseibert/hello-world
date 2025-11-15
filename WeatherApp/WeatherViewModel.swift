import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded(WeatherReport)
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    private let service: WeatherService

    init(service: WeatherService = WeatherService()) {
        self.service = service
    }

    func fetchWeather(for city: String) {
        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .failed("Please enter a city name.")
            return
        }

        state = .loading

        Task {
            do {
                let report = try await service.fetchWeather(for: city)
                state = .loaded(report)
            } catch {
                state = .failed("Couldn't load weather for \(city). Try again in a bit.")
            }
        }
    }
}
