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
            Color(red: 255/255, green: 214/255, blue: 165/255),  // Soft gold
                        Color(red: 255/255, green: 149/255, blue: 128/255)   // Gentle coral
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
