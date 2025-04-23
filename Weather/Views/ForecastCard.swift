//
//  ForecastCard.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/14/25.
//

import SwiftUI

struct ForecastCard: View {
    let day: ForecastDay

    var body: some View {
        VStack {
            Text(day.date)
                .font(.headline)
                .foregroundColor(.black)
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(day.icon)@2x.png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            Text(day.temp)
                .bold()
                .foregroundColor(.black)
            Text(day.description)
                .font(.caption)
                .foregroundColor(.black)
        }.forecastCardStyle()
    }
}

