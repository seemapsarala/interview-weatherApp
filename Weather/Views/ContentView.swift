//
//  ContentView.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/13/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @FocusState private var cityFieldFocused: Bool
    @State private var showingHourlyForecast = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                LinearGradient.weatherBackground
                        .ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Weather Overview").headerTextStyle()
                    TextField("Enter city name", text: $viewModel.city)
                        .cityTextFieldStyle()
                        .focused($cityFieldFocused)

                    Toggle(isOn: $viewModel.isMetric) {
                        Text(viewModel.isMetric ? "Metric (°C)" : "Imperial (°F)")
                    }.customStyledToggle()

                    VStack(spacing: 8) {
                        if !viewModel.currentTemp.isEmpty {
                            Text(viewModel.currentTemp)
                                .font(.system(size: 50, weight: .bold))

                            Text(viewModel.weatherDescription)
                                .font(.title2)
                        }

                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.icon)@2x.png")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                    }

                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing:0) {
                                ForEach(viewModel.forecast) { day in
                                    Button(action: {
                                        viewModel.selectedForecastDay = day
                                        viewModel.fetchHourlyForecast()
                                        showingHourlyForecast = true
                                    }) {
                                        ForecastCard(day: day)
                                    }
                                }
                            }
                            .padding(.horizontal, 0)
                        }
                        .sheet(isPresented: $showingHourlyForecast) {
                            HourlyForecastView(
                                hourlyForecast: viewModel.hourlyForecast,
                                isMetric: viewModel.isMetric, 
                                cityName: viewModel.selectedCity?.name ?? "Current Location",
                                forecastDay: viewModel.selectedForecastDay
                            )
                        }
                    }
                    .padding(.bottom, 30)
                    Divider()
                        .padding(.vertical, 8)

                    if viewModel.forecast.first != nil {
                        Text("Today’s Hourly Forecast").hourlyForecastStyle()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.hourlyForecast) { hour in
                                    VStack {
                                        Text(formatHour(hour.dt))
                                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(hour.weather.first?.icon ?? "01d")@2x.png")) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 30, height: 30)
                                        Text("\(Int(hour.temp))°\(viewModel.isMetric ? "C" : "F")")
                                    }
                                    .frame(width: 60)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        ProgressView("Loading forecast...")
                    }
                }

                if !viewModel.citySuggestions.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.citySuggestions, id: \.self) { city in
                                Text("\(city.name), \(city.state ?? ""), \(city.country)")
                                    .citySuggestionsTextStyle()
                                    .onTapGesture {
                                        viewModel.selectCity(city)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }.customScrollStyle()
                }
            }
        }
    }

    func formatHour(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
