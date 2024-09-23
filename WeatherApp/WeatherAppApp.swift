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
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                MyUIViewControllerRepresentable()
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        isFirstLaunch = false
                    }
            } else {
                let weatherVM = WeatherViewModel()
                WeatherDetailView(weatherVM: weatherVM)
            }
        }
    }
}

struct GlobalLocation {
    static var latitude: Double?
    static var longitude: Double?
}

struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return LocationViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Any updates go here if needed
    }
}
