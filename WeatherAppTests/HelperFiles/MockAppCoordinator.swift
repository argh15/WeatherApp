//
//  MockAppCoordinator.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation
@testable import WeatherApp

class MockCoordinator: AppCoordinator {
    var cityName: String?
    var error: CustomError?
    
    override func moveToNextScreen(with cityName: String?) {
        self.cityName = cityName
    }
    
    override func handleError(_ error: CustomError) {
        self.error = error
    }
}
