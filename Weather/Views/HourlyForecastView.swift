//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Sarala, Seema on 4/15/25.
//

import SwiftUI

enum ForecastDetailType: String, CaseIterable, Identifiable {
    case conditions = "Conditions"
    case uvIndex = "UV Index"
    case wind = "Wind"
    case humidity = "Humidity"

    var id: String { self.rawValue }
}

struct HourlyForecastView: View {
    let hourlyForecast: [HourlyForecast]
    let isMetric: Bool
    let cityName: String
    let forecastDay: ForecastDay?
    @Environment(\.dismiss) var dismiss
    @State private var selectedDetail: ForecastDetailType = .conditions

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.weatherSheetBackground
                    .ignoresSafeArea()
                VStack {
                    // Picker to switch between views
                    Picker("Detail", selection: $selectedDetail) {
                        ForEach(ForecastDetailType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    Text("Hourly Forecast for \(cityName)- \(forecastDay?.date ?? "Today")")
                        .font(.headline)

                    List(hourlyForecast) { hour in
                        HStack {
                            Text(formatHour(hour.dt))
                                .frame(width: 80, alignment: .leading)

                            switch selectedDetail {
                            case .conditions:
                                HStack {
                                    Text("\(Int(hour.temp))°\(isMetric ? "C" : "F")")
                                        .frame(width: 60, alignment: .leading)
                                    Text(hour.weather.first?.description.capitalized ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(hour.weather.first?.icon ?? "01d")@2x.png")) { image in
                                        image.resizable().frame(width: 30, height: 30)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }

                            case .uvIndex:
                                Text("UV: \(hour.uvi ?? 0, specifier: "%.1f")")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                            case .wind:
                                Text("Wind: \(hour.wind_speed, specifier: "%.1f") \(isMetric ? "m/s" : "mph")")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                            case .humidity:
                                Text("Humidity: \(hour.humidity)%")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }

                    Button("Close") {
                        dismiss()
                    }
                    .padding(.bottom)
                }
                .navigationTitle("Hourly Forecast")
            }

        }
    }

    private func formatHour(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}
