//
//  UIExtensions.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/14/25.
//

import SwiftUI

extension Color {
    static let bgcolor = Color("BackgroundColor")
    static let headerColor = Color("HeaderColor")
}

extension LinearGradient {
    static let weatherBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 255/255, green: 214/255, blue: 165/255),
                        Color(red: 255/255, green: 149/255, blue: 128/255)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    static let weatherSheetBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 255/255, green: 229/255, blue: 180/255),
            Color(red: 255/255, green: 183/255, blue: 160/255)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Text {
    func headerTextStyle() -> some View {
        self.font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color(red: 255/255, green: 180/255, blue: 140/255))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.bottom, 30)
    }

    func citySuggestionsTextStyle() -> some View {
        self.padding(.vertical, 6)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(6)
    }

    func hourlyForecastStyle() -> some View {
        self.font(.headline)
            .padding(.horizontal)
            .padding(.top, 15)
            .padding(.bottom, 15)
    }
}

extension TextField {
    func cityTextFieldStyle() -> some View {
        self.textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
}

extension Toggle {
    func customStyledToggle() -> some View {
        self.toggleStyle(SwitchToggleStyle(tint: .orange))
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}

extension ScrollView {
    func customScrollStyle() -> some View {
        self.background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(maxHeight: 150)
            .padding(.horizontal)
            .padding(.top, 120)
    }
}


extension VStack {
    func forecastCardStyle() -> some View {
        self.padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient.weatherSheetBackground)
            )
            .shadow(radius: 2)
            .padding(.horizontal,5)
    }
}
