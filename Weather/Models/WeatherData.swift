//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/13/25.
//

import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
    let daily: [DailyForecast]
}

struct CurrentWeather: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherCondition]
}

struct DailyForecast: Codable, Identifiable {
    var id: Int { dt }
    let dt: Int
    let temp: Temperature
    let weather: [WeatherCondition]
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String
}


