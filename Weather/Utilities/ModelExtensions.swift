//
//  ModelExtensions.swift
//  WeatherApp
//
//  Created by Sarala, Seema on 4/14/25.
//

import Foundation
import CoreLocation

extension WeatherViewModel {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        // Fetch the current weather using the coordinates
        fetchCurrentLocationWeather(latitude: latitude, longitude: longitude)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
