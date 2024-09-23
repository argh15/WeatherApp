//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import SwiftUI
import UIKit

@main
struct WeatherAppApp: App {
    
    @StateObject private var coordinator = AppCoordinator()
        
    var body: some Scene {
        WindowGroup {
            coordinator.currentView()
        }
        .environmentObject(coordinator)
    }
}
