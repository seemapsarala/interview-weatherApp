//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/13/25.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var city: String = ""
    @Published var currentTemp: String = "--"
    @Published var weatherDescription: String = ""
    @Published var icon: String = ""
    @Published var forecast: [ForecastDay] = []
    @Published var citySuggestions: [GeocodedCity] = []
    @Published var selectedCity: GeocodedCity?
    @Published var isMetric: Bool = true {
        didSet {
            if let city = selectedCity {
                fetchWeather(for: city)
            } else if let lat = currentLatitude, let lon = currentLongitude {
                fetchCurrentLocationWeather(latitude: lat, longitude: lon)
            }
//            if let city = selectedCity {
//                fetchWeather(for: city)
//            }
        }
    }
    @Published var cityInput: String = ""
    @Published var isSelectingCity = false
    private var cancellables = Set<AnyCancellable>()

    private var debounceTimer: AnyCancellable?

    private let apiKey = "5a0480768ed76f9e5ab5fb6b779f52a4"

    private let service = WeatherService()
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Auto-fetch suggestions as user types with debounce
        debounceTimer = $city
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if !self.isSelectingCity {
                    self.fetchCitySuggestions()
                } else {
                    self.isSelectingCity = false
                }
            }
    }

    func fetchWeather(for selectedCity: GeocodedCity) {
        Task {
            do {
                let lat = selectedCity.lat
                let lon = selectedCity.lon
                let unit = isMetric ? "metric" : "imperial"

                let data = try await service.getWeatherData(lat: lat, lon: lon, units: unit)

                DispatchQueue.main.async {
                    self.currentTemp = "\(Int(data.current.temp))°"
                    self.weatherDescription = data.current.weather.first?.main ?? ""
                    self.icon = data.current.weather.first?.icon ?? ""

                    self.forecast = data.daily.prefix(5).map { day in
                        ForecastDay(
                            date: self.formatDate(timestamp: day.dt),
                            temp: "\(Int(day.temp.day))°",
                            icon: day.weather.first?.icon ?? "",
                            description: day.weather.first?.main ?? ""
                        )
                    }
                }
            } catch {
                print("Error fetching weather: \(error)")
            }
        }
    }

    func fetchCitySuggestions() {
        Task {
            do {
                // Only call API when user has typed 2 or more characters
                guard city.count > 1 else {
                    DispatchQueue.main.async {
                        self.citySuggestions = []
                    }
                    return
                }

                let results = try await service.getCitySuggestions(for: city)
                DispatchQueue.main.async {
                    self.citySuggestions = results
                }
            } catch {
                print("Error fetching city suggestions: \(error)")
            }
        }
    }

    private var currentLatitude: Double?
    private var currentLongitude: Double?

    func fetchCurrentLocationWeather(latitude: Double, longitude: Double) {
        self.currentLatitude = latitude
        self.currentLongitude = longitude
        Task {
            do {
                let unit = isMetric ? "metric" : "imperial"
                let data = try await service.getWeatherData(lat: latitude, lon: longitude, units: unit)

                DispatchQueue.main.async {
                    self.currentTemp = "\(Int(data.current.temp))°"
                    self.weatherDescription = data.current.weather.first?.main ?? ""
                    self.icon = data.current.weather.first?.icon ?? ""

                    self.forecast = data.daily.prefix(5).map { day in
                        ForecastDay(
                            date: self.formatDate(timestamp: day.dt),
                            temp: "\(Int(day.temp.day))°",
                            icon: day.weather.first?.icon ?? "",
                            description: day.weather.first?.main ?? ""
                        )
                    }
                }
            } catch {
                print("Error fetching current location weather: \(error)")
            }
        }
    }

    private func formatDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
                formatter.timeStyle = .none
//        formatter.dateFormat = "E" // Short weekday format (e.g., Mon, Tue)
        return formatter.string(from: date)
    }

    func selectCity(_ selected: GeocodedCity) {
        isSelectingCity = true
        let cityText = [selected.name, selected.state, selected.country]
                .compactMap { $0 }
                .joined(separator: ", ")
        city = cityText
        citySuggestions = []
        selectedCity = selected
        fetchWeather(for: selected)
    }

}


struct GeocodedCity: Decodable, Hashable {
//    var id: UUID = UUID()
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String
    let temp: String
    let icon: String
    let description: String
}
