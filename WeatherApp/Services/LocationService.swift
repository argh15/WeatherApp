//
//  LocationService.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation
import CoreLocation

final class LocationService {
    
    static let sharedInstance = LocationService()
    
    private init() { }
    
    func getCoordinates(from address: String,
                        completion: @escaping (Result<Coordinates, CustomError>) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
            }
            
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                
                let coordinates = Coordinates(lat: lat.convertToDouble(), lon: lon.convertToDouble())
                completion(.success(coordinates))
            } else {
                completion(.failure(.error("Failed to get coordinates.")))
            }
        }
    }
}
