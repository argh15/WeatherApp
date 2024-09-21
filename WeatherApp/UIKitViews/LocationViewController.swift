//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation
import UIKit

final class LocationViewController: UIViewController {
    
    var isDayTime: Bool = true
    let searchTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGradientBasedOnTime()
        setupUI()
    }
    
    func updateGradientBasedOnTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 6 && hour < 18 {
            isDayTime = true
            setDayGradient()
        } else {
            isDayTime = false
            setNightGradient()
        }
        
        updatePlaceholderColor()
    }
    
    func setDayGradient() {
        let dayGradientLayer = CAGradientLayer()
        dayGradientLayer.colors = [
            UIColor(red: 0.1, green: 0.6, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.9, green: 0.85, blue: 0.5, alpha: 1).cgColor
        ]
        dayGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        dayGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        dayGradientLayer.frame = view.bounds
        view.layer.insertSublayer(dayGradientLayer, at: 0)
    }
    
    func setNightGradient() {
        let nightGradientLayer = CAGradientLayer()
        nightGradientLayer.colors = [
            UIColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.1, blue: 0.4, alpha: 1).cgColor
        ]
        nightGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        nightGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        nightGradientLayer.frame = view.bounds
        view.layer.insertSublayer(nightGradientLayer, at: 0)
    }
    
    func updatePlaceholderColor() {
        let placeholderColor: UIColor = isDayTime ? UIColor.white.withAlphaComponent(0.4) : UIColor.lightGray
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter city name",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
    
    func setupUI() {
        // Large Title Label
        let largeTitleLabel = UILabel()
        largeTitleLabel.text = "Welcome to the Weather App"
        largeTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        largeTitleLabel.textAlignment = .center
        largeTitleLabel.textColor = .white
        largeTitleLabel.numberOfLines = 2
        largeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Body Label
        let bodyLabel = UILabel()
        bodyLabel.text = "Please enter a city name or share your location to get the weather in your area"
        bodyLabel.font = UIFont.systemFont(ofSize: 17)
        bodyLabel.textAlignment = .center
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // TextField for City Search
        searchTextField.placeholder = "Enter city name"
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        searchTextField.textColor = .white
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = 16 // Adjust the padding as needed
        
        let searchButton = UIButton(configuration: configuration, primaryAction: nil)
        searchButton.tintColor = .white
        
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
        
        // 'Or' Label
        let orLabel = UILabel()
        orLabel.text = "or"
        orLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        orLabel.textAlignment = .center
        orLabel.textColor = .white
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Share Location Button
        let shareLocationButton = UIButton(type: .system)
        shareLocationButton.setTitle("Share Location", for: .normal)
        shareLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        shareLocationButton.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        shareLocationButton.setTitleColor(.white, for: .normal)
        shareLocationButton.layer.cornerRadius = 5
        shareLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Add subviews
        containerView.addSubview(largeTitleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(searchTextField)
        containerView.addSubview(orLabel)
        containerView.addSubview(shareLocationButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Center vertically
            largeTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor), // Align with top of container
            largeTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            largeTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Body Label
            bodyLabel.topAnchor.constraint(equalTo: largeTitleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            
            // Search TextField
            searchTextField.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // 'Or' Label
            orLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            orLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            // Share Location Button
            shareLocationButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            shareLocationButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shareLocationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            shareLocationButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            shareLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
