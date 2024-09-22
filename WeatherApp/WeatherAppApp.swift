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
    var body: some Scene {
        WindowGroup {
            MyUIViewControllerRepresentable()
                .edgesIgnoringSafeArea(.all)
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
