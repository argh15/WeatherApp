//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI
import UIKit

protocol AppCoordinatorProtocol {
    func moveToNextScreen(with cityName: String?)
    func handleError(_ error: CustomError) // Add this line
}

class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State var selectedCity: String?
    
    @ViewBuilder
    func currentView() -> some View {
        if isFirstLaunch {
            LocationViewControllerRepresentable()
                .edgesIgnoringSafeArea(.all)
        } else {
            let weatherVM = WeatherViewModel(cityName: selectedCity)
            WeatherDetailContainerView(weatherVM: weatherVM)
        }
    }
    
    func completeFirstLaunch() {
        isFirstLaunch = false
    }
    
    func moveToNextScreen(with cityName: String?) {
        self.selectedCity = cityName
        completeFirstLaunch()
    }
    
    func handleError(_ error: CustomError) {
        print("Error occurred: \(error.localizedDescription)")
    }
}
