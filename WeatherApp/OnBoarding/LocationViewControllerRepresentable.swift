//
//  LocationViewControllerRepresentable.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import Foundation
import SwiftUI

struct LocationViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    var onComplete: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let locationVM = LocationViewModel(coordinator: coordinator)
        let viewController = LocationViewController(viewModel: locationVM)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Any updates go here if needed
    }
}
