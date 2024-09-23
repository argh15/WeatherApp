//
//  MockLocationService.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation
@testable import WeatherApp

class MockLocationService: LocationServiceProtocol {
    
    var mockGetCoordinatesResult: Result<(Double, Double), CustomError>?
    var mockRequestLocationResult: Result<Void, CustomError>?
    
    func getCoordinates(from city: String, completion: @escaping (Result<(Double, Double), CustomError>) -> Void) {
        if city == "InvalidCityName" {
            // Pass the exact error string you expect in your test
            completion(.failure(.error("Invalid city")))
        } else if let result = mockGetCoordinatesResult {
            completion(result)
        }
    }
    
    func requestLocationPermission(completion: @escaping (Result<Void, CustomError>) -> Void) {
        if let result = mockRequestLocationResult {
            completion(result)
        }
    }
}
