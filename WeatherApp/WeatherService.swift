import Foundation

struct WeatherReport: Equatable {
    let city: String
    let summary: String
    let temperature: Double
    let apparentTemperature: Double
    let windSpeed: Double
    let humidity: Double
}

struct WeatherService {
    enum ServiceError: Error {
        case invalidResponse
    }

    private let geocodingBaseURL = "https://geocoding-api.open-meteo.com/v1/search"
    private let weatherBaseURL = "https://api.open-meteo.com/v1/forecast"

    func fetchWeather(for city: String) async throws -> WeatherReport {
        let (latitude, longitude, resolvedName) = try await geocode(city: city)
        return try await weather(latitude: latitude, longitude: longitude, city: resolvedName)
    }

    private func geocode(city: String) async throws -> (Double, Double, String) {
        guard var components = URLComponents(string: geocodingBaseURL) else {
            throw ServiceError.invalidResponse
        }
        components.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else { throw ServiceError.invalidResponse }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.invalidResponse
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GeocodingResponse.self, from: data)
        guard let first = result.results?.first else {
            throw ServiceError.invalidResponse
        }
        return (first.latitude, first.longitude, first.name)
    }

    private func weather(latitude: Double, longitude: Double, city: String) async throws -> WeatherReport {
        guard var components = URLComponents(string: weatherBaseURL) else {
            throw ServiceError.invalidResponse
        }

        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,apparent_temperature,wind_speed_10m,relative_humidity_2m,weather_code"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        guard let url = components.url else { throw ServiceError.invalidResponse }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.invalidResponse
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(WeatherResponse.self, from: data)

        guard let current = result.currentWeather else {
            throw ServiceError.invalidResponse
        }

        return WeatherReport(
            city: city,
            summary: WeatherCodeFormatter.description(for: current.weatherCode),
            temperature: current.temperature,
            apparentTemperature: current.apparentTemperature,
            windSpeed: current.windSpeed,
            humidity: current.humidity
        )
    }
}
