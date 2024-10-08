//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import UIKit
import SwiftUI
import CoreLocation

final class LocationViewController: UIViewController {
    
    private let searchTextField = UITextField()
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private var viewModel: LocationViewModel
    
    init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGradientBasedOnTime()
        setupScrollView()
        setupUI()
        setupGesture()
        
        searchTextField.delegate = self
        
        setupKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientLayer()
    }
    
    private func updateGradientLayer() {
        if let layers = view.layer.sublayers {
            for layer in layers {
                if layer is CAGradientLayer {
                    layer.frame = view.bounds
                }
            }
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        adjustScrollViewForKeyboard(notification: notification, isShowing: true)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        adjustScrollViewForKeyboard(notification: notification, isShowing: false)
    }
    
    private func adjustScrollViewForKeyboard(notification: Notification, isShowing: Bool) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            scrollView.contentInset.bottom = isShowing ? keyboardHeight : 0
            scrollView.verticalScrollIndicatorInsets.bottom = isShowing ? keyboardHeight : 0
        }
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    @objc private func fetchLocation() {
        viewModel.fetchUserLocation()
    }
    
    @objc private func performSearch() {
        if let text = searchTextField.text, !text.isEmpty {
            viewModel.onBoardingComplete(with: text)
        } else {
            showLocationAlert()
        }
        dismissKeyboard()
    }
    
    private func showLocationAlert() {
        let alert = UIAlertController(
            title: Constants.EmptyLocationAlertView.title,
            message: Constants.EmptyLocationAlertView.message,
            preferredStyle: .alert
        )
        let dismissAction = UIAlertAction(title: Constants.EmptyLocationAlertView.buttonTitle, style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateGradientBasedOnTime() {
        Helpers.isNight ? setNightGradient() : setDayGradient()
        updatePlaceholderColor()
    }
    
    private func setDayGradient() {
        let dayGradientLayer = CAGradientLayer()
        dayGradientLayer.colors = [
            UIColor(red: 0.1, green: 0.6, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.9, green: 0.85, blue: 0.5, alpha: 1).cgColor
        ]
        dayGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        dayGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        dayGradientLayer.frame = view.bounds
        view.layer.insertSublayer(dayGradientLayer, at: 0)
    }
    
    private func setNightGradient() {
        let nightGradientLayer = CAGradientLayer()
        nightGradientLayer.colors = [
            UIColor(red: 0.0, green: 0.0, blue: 0.1, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.1, blue: 0.4, alpha: 1).cgColor
        ]
        nightGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        nightGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        nightGradientLayer.frame = view.bounds
        view.layer.insertSublayer(nightGradientLayer, at: 0)
    }
    
    private func updatePlaceholderColor() {
        let placeholderColor: UIColor = Helpers.isNight ? UIColor.lightGray : UIColor.white.withAlphaComponent(0.4)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.SearchView.placeholderUIKit,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        // Create and configure MiddleView
        let middleView = UIView()
        middleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(middleView)
        
        // Centering MiddleView in ContainerView
        NSLayoutConstraint.activate([
            middleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            middleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            middleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            middleView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 20),
            middleView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Large Title Label
        let largeTitleLabel = UILabel()
        largeTitleLabel.text = Constants.OnBoardingView.title
        largeTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        largeTitleLabel.textAlignment = .center
        largeTitleLabel.textColor = .white
        largeTitleLabel.numberOfLines = 2
        largeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Body Label
        let bodyLabel = UILabel()
        bodyLabel.text = Constants.OnBoardingView.message
        bodyLabel.font = UIFont.systemFont(ofSize: 17)
        bodyLabel.textAlignment = .center
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // TextField for City Search
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        searchTextField.textColor = .white
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: Constants.ImageNames.searchIcon)
        configuration.imagePadding = 16
        
        let searchButton = UIButton(configuration: configuration, primaryAction: nil)
        searchButton.tintColor = .white
        searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
        
        // 'Or' Label
        let orLabel = UILabel()
        orLabel.text = Constants.OnBoardingView.orText
        orLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        orLabel.textAlignment = .center
        orLabel.textColor = .white
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Share Location Button
        let shareLocationButton = UIButton(type: .system)
        shareLocationButton.setTitle(Constants.OnBoardingView.shareLocButtonText, for: .normal)
        shareLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        shareLocationButton.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        shareLocationButton.setTitleColor(.white, for: .normal)
        shareLocationButton.layer.cornerRadius = 5
        shareLocationButton.translatesAutoresizingMaskIntoConstraints = false
        shareLocationButton.addTarget(self, action: #selector(fetchLocation), for: .touchUpInside)
        
        
        // Add subviews to MiddleView
        middleView.addSubview(largeTitleLabel)
        middleView.addSubview(bodyLabel)
        middleView.addSubview(searchTextField)
        middleView.addSubview(orLabel)
        middleView.addSubview(shareLocationButton)
        
        // Layout Constraints for MiddleView's subviews
        NSLayoutConstraint.activate([
            // Large Title Label
            largeTitleLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 40),
            largeTitleLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            largeTitleLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            
            // Body Label
            bodyLabel.topAnchor.constraint(equalTo: largeTitleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            
            // Search TextField
            searchTextField.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // 'Or' Label
            orLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            orLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            
            // Share Location Button
            shareLocationButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            shareLocationButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            shareLocationButton.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 20),
            shareLocationButton.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -20),
            shareLocationButton.heightAnchor.constraint(equalToConstant: 44),
            shareLocationButton.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -20)
        ])
    }
}

extension LocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}
