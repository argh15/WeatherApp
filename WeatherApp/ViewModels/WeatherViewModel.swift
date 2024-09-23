//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    
    @Published var weatherModel: WeatherModel? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @AppStorage("userLatitude") var userLatitude: Double?
    @AppStorage("userLongitude") var userLongitude: Double?
    
    let apiService = APIService.sharedInstance
    let locationService = LocationService.sharedInstance
    var cityName: String?
    
    init(cityName: String? = nil) {
        self.cityName = cityName
        checkForUserDefaults()
    }
    
    private func checkForUserDefaults() {
        GlobalLocation.latitude = userLatitude
        GlobalLocation.longitude = userLongitude
    }
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.shortHandFormatE_MMM_d
    }
    
    private static var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.timeFormath_mm_a
    }
    
    private static var numberFormmater: NumberFormatter {
        let numberFormatter = NumberFormatter()
        return numberFormatter.wholeNumber
    }
    
    var location: String {
        return weatherModel?.name ?? "N/A"
    }
    
    var overview: String {
        weatherModel?.weather?.first?.description?.capitalized ?? "N/A"
    }
    
    var currentTemp: String {
        return "\(Self.numberFormmater.string(for: weatherModel?.main?.temp) ?? "N/A")°"
    }
    
    var lowTemp: String {
        return "L: \(Self.numberFormmater.string(for: weatherModel?.main?.tempMin) ?? "N/A")°"
    }
    
    var highTemp: String {
        return "H: \(Self.numberFormmater.string(for: weatherModel?.main?.tempMax) ?? "N/A")°"
    }
    
    var isRainSnowDataPresent: Bool {
        if let _ = weatherModel?.rain, let _ = weatherModel?.snow {
            return true
        }
        return false
    }
    
    var rainOrSnowPrecipitation: String {
        if let rain = weatherModel?.rain {
            return "Rain: \(rain) mm/h"
        } else if let snow = weatherModel?.snow {
            return "Snow: \(snow) mm/h"
        } else {
            return "N/A"
        }
    }
    
    var sunrise: String {
        guard let sunrise = weatherModel?.sys?.sunrise else { return "N/A" }
        return "Sunrise: \(Self.timeFormatter.string(from: sunrise))"
    }
    
    var sunset: String {
        guard let sunset = weatherModel?.sys?.sunset else { return "N/A" }
        return "Sunset: \(Self.timeFormatter.string(from: sunset))"
    }
    
    var date: String {
        guard let date = weatherModel?.dt else { return "N/A" }
        return Self.dateFormatter.string(from: date)
    }
    
    var windSpeed: String {
        return "\(Self.numberFormmater.string(for: weatherModel?.wind?.speed) ?? "N/A")"
    }
    
    var gustSpeed: String {
        return "\(Self.numberFormmater.string(for: weatherModel?.wind?.gust) ?? "N/A")"
    }
    
    var windDirectionDeg: Double {
        return Double(weatherModel?.wind?.deg ?? 0)
    }
    
    var windDirection: String {
        guard let windDirection = weatherModel?.wind?.deg else { return "N/A" }
        return "\(windDirection)°"
    }
    
    var humidity: String {
        guard let humidity = weatherModel?.main?.humidity else { return "N/A" }
        return "\(humidity)%"
    }
    
    var humidityVerbiage: String {
        guard let humidity = weatherModel?.main?.humidity else { return "Sorry, there is no data!" }
        if humidity >= 0 && humidity <= 30 {
            return "Comfortable air with balanced humidity."
        } else if humidity >= 31 && humidity <= 69 {
            return "The air feels comfortable with a mild level of humidity."
        } else if humidity >= 70 && humidity <= 100 {
            return "The humidity is adding to the warmth today."
        } else {
            return "Sorry, there is no data!"
        }
    }
    
    var clouds: String {
        guard let clouds = weatherModel?.clouds?.all else { return "N/A" }
        return "\(clouds)%"
    }
    
    var cloudsVerbiage: String {
        guard let clouds = weatherModel?.clouds?.all else { return "Sorry, there is no data!" }
        if clouds >= 0 && clouds <= 25 {
            return "Clear skies with minimal clouds."
        } else if clouds >= 26 && clouds <= 75 {
            return "Partly cloudy with a mix of sun and clouds."
        } else if clouds >= 76 && clouds <= 100 {
            return "Overcast with heavy cloud cover."
        } else {
            return "Sorry, there is no data!"
        }
    }
    
    var feelsLike: String {
        return "\(Self.numberFormmater.string(for: weatherModel?.main?.feelsLike) ?? "N/A")°"
    }
    
    var feelsLikeVerbiage: String {
        guard let feelsLike = weatherModel?.main?.feelsLike, let currentTemp = weatherModel?.main?.temp  else { return "Sorry, there is no data!" }
        let difference = abs(currentTemp - feelsLike)
        if difference >= 0 && difference <= 2 {
            return "Feels as expected, matching the actual temperature."
        } else if difference >= 2.1 && difference <= 5 {
            return "Feels noticeably warmer/cooler than the actual temperature."
        } else if difference >= 5.1 {
            return "Significantly warmer/cooler than the actual temperature, dress accordingly."
        } else {
            return "Sorry, there is no data!"
        }
    }
    
    var visibility: String {
        guard let visibility = weatherModel?.visibility else { return "N/A" }
        let visibilityInMeters = Measurement(value: Double(visibility), unit: UnitLength.meters)
        let visibilityInMiles = visibilityInMeters.converted(to: .miles).value
        return String(format: "%.1f mi", visibilityInMiles)
    }
    
    var visibilityVerbiage: String {
        guard let visibility = weatherModel?.visibility else { return "Sorry, there is no data!" }
        if visibility >= 0 && visibility <= 3000 {
            return "Visibility is poor, fog or heavy precipitation affecting clarity."
        } else if visibility >= 3001 && visibility <= 8000 {
            return "Visibility is moderate, some haze present."
        } else if visibility >= 8001 && visibility <= 10000 {
            return "Visibility is excellent, clear conditions."
        } else {
            return "Sorry, there is no data!"
        }
    }
    
    func fetchData(currentLocation: Bool = false, onRetry: Bool = false) {
        isLoading = true
        errorMessage = nil
        
        if onRetry {
            checkForUserDefaults()
        }
        
        if currentLocation {
            self.cityName = nil
            self.weatherModel = nil
            
            // Check if we already have the latitude and longitude
            if GlobalLocation.latitude != nil && GlobalLocation.longitude != nil {
                fetchWeatherData(lat: GlobalLocation.latitude, lon: GlobalLocation.longitude)
            } else {
                // Request location if it isn't set
                locationService.requestLocationPermission { [weak self] result in
                    switch result {
                    case .success:
                        self?.fetchWeatherData(lat: GlobalLocation.latitude, lon: GlobalLocation.longitude)
                    case .failure(let error):
                        self?.errorMessage = "Failed to get location: \(error.localizedDescription)"
                        self?.isLoading = false
                    }
                }
            }
        } else if let cityName = cityName {
            locationService.getCoordinates(from: cityName) { [weak self] result in
                switch result {
                case .success((let lat, let lon)):
                    self?.fetchWeatherData(lat: lat, lon: lon)
                case .failure(let error):
                    self?.errorMessage = "Error fetching coordinates: \(error.localizedDescription)"
                    self?.isLoading = false
                }
            }
        } else {
            self.isLoading = false
            self.errorMessage = "No location information provided."
        }
    }
    
    
    func fetchWeatherData(lat: Double?, lon: Double?) {
        
        guard let lat = lat, let lon = lon else {
            errorMessage = "Coordinates not available."
            isLoading = false
            return
        }
        
        userLatitude = lat
        userLongitude = lon
        
        apiService.getData(from: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=3f605b4d76506707219e34688a1229b6&units=imperial") { [weak self] (result: Result<WeatherModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.weatherModel = data
                    self?.isLoading = false
                case .failure(let failure):
                    self?.errorMessage = failure.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
}
