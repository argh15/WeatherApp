//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation

final class LocationViewModel {
    
    private weak var coordinator: AppCoordinator?
    private var locationService: LocationServiceProtocol
    
    init(coordinator: AppCoordinator?, locationService: LocationServiceProtocol = LocationService.sharedInstance) {
        self.coordinator = coordinator
        self.locationService = locationService
    }
    
    func onBoardingComplete(with cityName: String?) {
        coordinator?.moveToNextScreen(with: cityName)
    }
    
    func fetchUserLocation() {
        locationService.requestLocationPermission { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.moveToNextScreen(with: nil)
            case .failure(let error):
                self?.coordinator?.handleError(error)
            }
        }
    }
}
