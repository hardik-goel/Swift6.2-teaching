import SwiftUI
import Foundation

// MARK: - Models (matches open-meteo minimal)
struct WeatherResponse: Codable {
    let current_weather: CurrentWeather
}
struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
}

// MARK: - ViewModel (real network available; preview uses mock)
@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var windSpeed: Double?
    @Published var cityName: String = "New Delhi"
    @Published var isLoading = false
    @Published var lastUpdated: Date?

    // Live fetch (async/await)
    func fetchWeather(lat: Double = 28.61, lon: Double = 77.23) async {
        isLoading = true
        defer { isLoading = false }
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true"
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let resp = try JSONDecoder().decode(WeatherResponse.self, from: data)
            temperature = resp.current_weather.temperature
            windSpeed = resp.current_weather.windspeed
            lastUpdated = Date()
        } catch {
            print("Weather fetch error:", error)
        }
    }

    // For preview: set mock data quickly
    func loadMock() {
        temperature = 30.4
        windSpeed = 5.6
        cityName = "San Francisco"
        lastUpdated = Date()
    }
}

// MARK: - View
struct WeatherView: View {
    @StateObject var vm = WeatherViewModel()

    var body: some View {
        ZStack {
            // background gradient
            LinearGradient(colors: [Color.blue.opacity(0.9), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.cityName)
                            .font(.largeTitle)
                            .bold()
                        if let updated = vm.lastUpdated {
                            Text("Updated: \(updated.formatted(date: .omitted, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.yellow, .orange)
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        if let temp = vm.temperature {
                            Text("\(temp, specifier: "%.1f")°C")
                                .font(.system(size: 48, weight: .heavy, design: .rounded))
                        } else {
                            Text("--°C")
                                .font(.system(size: 48, weight: .heavy, design: .rounded))
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("Feels like").font(.caption).foregroundColor(.secondary)
                            if let ws = vm.windSpeed {
                                Text("\(ws, specifier: "%.1f") m/s")
                                    .font(.headline)
                            } else {
                                Text("-- m/s").font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // small info bar
                    HStack {
                        Label("Humidity", systemImage: "drop.fill")
                        Spacer()
                        Text("—")
                        Spacer().frame(width: 8)
                        Label("Pressure", systemImage: "gauge")
                        Spacer()
                        Text("—")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer()

                HStack {
                    Button {
                        Task {
                            await vm.fetchWeather()
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()

                    Button {
                        // design-only: copy share action for demo
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 36)
            .padding(.bottom, 20)
        }
        .task {
            // For demo, load mock immediately
            if vm.temperature == nil { vm.loadMock() }
        }
    }
}

// MARK: - Preview (renders static image in Xcode canvas)
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherView()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("Light Mode")
            WeatherView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("Dark Mode")
        }
    }
}

