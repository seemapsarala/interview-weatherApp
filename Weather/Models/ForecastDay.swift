//
//  ForecastDay.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/14/25.
//

import Foundation

struct ForecastDay: Identifiable {
    let id = UUID()
    let date: String
    let temp: String
    let icon: String
    let description: String
}
