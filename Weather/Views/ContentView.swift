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

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                LinearGradient.weatherBackground
                        .ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Weather Overview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 255/255, green: 180/255, blue: 140/255))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.bottom, 30)

                    TextField("Enter city name", text: $viewModel.city)
                        .focused($cityFieldFocused)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Toggle(isOn: $viewModel.isMetric) {
                        Text(viewModel.isMetric ? "Metric (°C)" : "Imperial (°F)")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

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

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.forecast) { day in
                                ForecastCard(day: day)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                
                if !viewModel.citySuggestions.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.citySuggestions, id: \.self) { city in
                                Text("\(city.name), \(city.state ?? ""), \(city.country)")
                                    .padding(.vertical, 6)
                                    .padding(.horizontal)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(6)
                                    .onTapGesture {
                                        viewModel.selectCity(city)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxHeight: 150)
                    .padding(.horizontal)
                    .padding(.top, 120) // Adjust based on the TextField height
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
