//
//  Enums.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

public enum CustomError: Error {
    case error(_ errorString: String)
}

////MARK: - APIError
//public enum APIError: Error {
//    case invalidPath
//    case decoding
//}
//
//extension APIError {
//    var localizedDescription: String {
//        switch self {
//        case .invalidPath:
//            return "Invalid Path"
//        case .decoding:
//            return "There was an error decoding the type"
//        }
//    }
//}
//
////MARK: - APIEndpoint
//public enum APIEndpoint {
//    case getWeatherData(lat: String, lon: String, appid: String, units: String?)
//}
//
//extension APIEndpoint {
//
//    var path: String {
//        switch self {
//        case .getWeatherData(let lat, let lon, let appid, let units):
//            return "https://api.openweathermap.org/data/2.5/weather"
//        }
//    }
//
//    var parameters: [URLQueryItem]? {
//        switch self {
//        case .getWeatherData(let lat, let lon, let appid, let units):
//            var queryItems = [URLQueryItem]()
//            queryItems.append(URLQueryItem(name: "lat", value: lat))
//            queryItems.append(URLQueryItem(name: "lon", value: lon))
//            queryItems.append(URLQueryItem(name: "appid", value: appid))
//            if let units = units {
//                queryItems.append(URLQueryItem(name: "units", value: units))
//            }
//            return queryItems
//        }
//    }
//}
//
//public enum APIRequestMethod: String {
//    case GET
//    case POST
//    case PUT
//    case DELETE
//}
