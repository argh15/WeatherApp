//
//  APIEnums.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

enum CustomError: Error {
    case error(_ errorString: String)
}

enum ApiEndpoint {
    case getWeather(lat: Double, lon: Double)
    
    var path: String {
        switch self {
        case .getWeather(let lat, let lon):
            return "/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var url: URL? {
        return URL(string: Constants.Endpoints.baseURL + path)
    }
    
    private var apiKey: String {
        return ProcessInfo.processInfo.environment["WEATHER_API_KEY"] ?? ""
    }
}
