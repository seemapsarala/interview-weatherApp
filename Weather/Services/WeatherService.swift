//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/13/25.
//

import Foundation

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

class WeatherService {
    private let apiKey = "5a0480768ed76f9e5ab5fb6b779f52a4"

    // Geocoding API to convert a city name into latitude and longitude.
    func getCoordinates(for city: String) async throws -> Coordinates {
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlStr = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityEscaped)&limit=1&appid=\(apiKey)"
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode([Coordinates].self, from: data)

        guard let first = results.first else {
            throw NSError(domain: "City not found", code: 404, userInfo: nil)
        }

        return first
    }

    // One Call API: Fetches current weather and daily forecast.
    func getWeatherData(lat: Double, lon: Double, units: String = "metric") async throws -> WeatherData {
        let urlStr = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=\(units)&appid=\(apiKey)"
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }

    func getCitySuggestions(for city: String) async throws -> [GeocodedCity] {
        guard let urlCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }

        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(urlCity)&limit=5&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode([GeocodedCity].self, from: data)
    }


}


