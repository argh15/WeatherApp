//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation

final class LocationViewModel {
    
    private weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator?) {
        self.coordinator = coordinator
    }
    
    func onBoardingComplete(with cityName: String?) {
        coordinator?.moveToNextScreen(with: cityName)
    }

    func fetchUserLocation() {
        LocationService.sharedInstance.requestLocationPermission { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.moveToNextScreen(with: nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
