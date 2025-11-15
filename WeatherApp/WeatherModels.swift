import Foundation

struct GeocodingResponse: Decodable {
    struct Result: Decodable {
        let name: String
        let latitude: Double
        let longitude: Double
        let country: String?
        let admin1: String?
    }

    let results: [Result]?
}

struct WeatherResponse: Decodable {
    struct CurrentWeather: Decodable {
        let time: String
        let temperature: Double
        let apparentTemperature: Double
        let windSpeed: Double
        let humidity: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case time
            case temperature = "temperature_2m"
            case apparentTemperature = "apparent_temperature"
            case windSpeed = "wind_speed_10m"
            case humidity = "relative_humidity_2m"
            case weatherCode = "weather_code"
        }
    }

    let currentWeather: CurrentWeather?

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current"
    }
}

enum WeatherCodeFormatter {
    static func description(for code: Int) -> String {
        switch code {
        case 0: return "Clear sky"
        case 1, 2, 3: return "Partly cloudy"
        case 45, 48: return "Foggy"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 80, 81, 82: return "Showers"
        case 95: return "Thunderstorm"
        default: return "Unknown"
        }
    }
}
