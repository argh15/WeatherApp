//
//  Constants.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

struct Constants {
    
    struct ViewDimensions {
        static let weatherDetailCardViewHeight: CGFloat = 120
    }
    
    struct Endpoints {
        static let baseURL = "https://api.openweathermap.org"
    }
    
    struct EmptyLocationAlertView {
        static let title = "Location Required"
        static let message = "Can't proceed without location information. Please either enter a city name or share your current location."
        static let buttonTitle = "Dismiss"
    }
    
    struct SearchView {
        static let placeholderUIKit = "Enter city name"
    }
    
    struct OnBoardingView {
        static let title = "Welcome to the Weather App"
        static let message = "Please enter a city name or share your location to get the weather in your area"
        static let orText = "or"
        static let shareLocButtonText = "Share Location"
    }
    
    struct ImageNames {
        static let searchIcon = "magnifyingglass"
    }
}
