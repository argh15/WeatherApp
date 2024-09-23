//
//  MockAPIService.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation
@testable import WeatherApp

class MockAPIService: APIServiceProtocol {
    
    var mockWeatherData: WeatherModel?
    
    func getData(from endpoint: ApiEndpoint,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
                 completion: @escaping (Result<WeatherModel, CustomError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if let data = self?.mockWeatherData {
                completion(.success(data))
            } else {
                completion(.failure(CustomError.error("No data")))
            }
        }
    }
    
    func requestLocationPermission(completion: @escaping (Result<Void, CustomError>) -> Void) {
        // Simulate location permission success and setting the global coordinates
        GlobalLocation.latitude = 37.7749
        GlobalLocation.longitude = -122.4194
        completion(.success(()))
    }
}
