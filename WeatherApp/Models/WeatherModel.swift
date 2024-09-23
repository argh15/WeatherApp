//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//
// not considering the units -> default is standard from API documentation

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain, snow: RainSnow?
    let clouds: Clouds?
    let dt: Date?
    let sys: Sys?
    let name: String?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?
}

// MARK: - RainSnow
struct RainSnow: Codable {
    let the1H: Double?
}

// MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Date?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
    var iconURL: URL? {
        guard let icon = icon else { return nil }
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
