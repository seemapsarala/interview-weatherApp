//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/14/25.
//

import SwiftUI

struct CitySearchView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            TextField("Enter city namee", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Show suggestions
//            if !viewModel.citySuggestions.isEmpty {
//                List(viewModel.citySuggestions, id: \.self) { suggestion in
//                    Text(suggestion)
//                        .onTapGesture {
//                            viewModel.city = suggestion
//                            viewModel.citySuggestions = [] // hide list
//                        }
//                }
//                .frame(height: 150)
//            }
        }
    }
}

