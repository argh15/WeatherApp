//
//  LocationService.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    
    private let locationManager = CLLocationManager()
    private var didUpdateLocation: ((Result<Void, CustomError>) -> Void)?
    private var lastKnownLatitude: Double?
    private var lastKnownLongitude: Double?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCoordinates(from address: String,
                        completion: @escaping (Result<(Double, Double), CustomError>) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                
                completion(.success((lat.convertToDouble(), lon.convertToDouble())))
            } else {
                completion(.failure(.error("Failed to get coordinates.")))
            }
        }
    }
    
    // Request permission and get the current location
    func requestLocationPermission(completion: @escaping (Result<Void, CustomError>) -> Void) {
        self.didUpdateLocation = completion
        
        // Check the current authorization status
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            completion(.failure(.error("Location access is denied or restricted.")))
        @unknown default:
            completion(.failure(.error("Unknown authorization status.")))
        }
    }
    
    // CLLocationManagerDelegate method for successful location update
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied access
            didUpdateLocation?(.failure(.error("Location access denied.")))
            print("Location access denied.")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
                didUpdateLocation?(.failure(.error("Failed to get location.")))
                return
            }
        
        GlobalLocation.latitude = location.coordinate.latitude
        GlobalLocation.longitude = location.coordinate.longitude
        
        didUpdateLocation?(.success(()))
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
