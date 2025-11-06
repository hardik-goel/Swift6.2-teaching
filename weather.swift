import Foundation

// Define the model that matches Open-Meteo’s API response
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let current_weather: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
}

func fetchWeather(for city: String) async {
    // New Delhi (latitude, longitude)
    let apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=28.61&longitude=77.23&current_weather=true"
    guard let url = URL(string: apiUrl) else {
        print("Invalid URL.")
        return
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
        print("🌦️ City: \(city)")
        print("Temperature: \(decoded.current_weather.temperature)°C")
        print("Wind Speed: \(decoded.current_weather.windspeed)m/s")
        print("Weather Code: \(decoded.current_weather.weathercode)")
    } catch {
        print("❌ Error fetching or decoding weather data: \(error)")
    }
}

@main
struct WeatherApp {
    static func main() async {
        print("Fetching live weather for New Delhi...")
        await fetchWeather(for: "New Delhi")
    }
}

