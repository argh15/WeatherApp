//
//  WeatherDetailContainerView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/22/24.
//

import SwiftUI

struct WeatherDetailContainerView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    @State private var showAlert = false
    @State private var searchText = ""
    @State private var keyboardHeight: CGFloat = 0
    
    init(weatherVM: WeatherViewModel) {
        self.weatherVM = weatherVM
    }
    
    var body: some View {
        ZStack {
            if Helpers.isNight {
                NightGradientView()
            } else {
                DayGradientView()
            }
            
            VStack {
                if weatherVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .tint(.white)
                        .foregroundStyle(.white)
                } else if let errorMessage = weatherVM.errorMessage {
                    ErrorView(
                            errorImage: Image(systemName: "exclamationmark.triangle.fill"),
                            errorTitle: "Weather Fetch Error",
                            errorDescription: errorMessage, onRetry: {
                                weatherVM.fetchData(onRetry: true)
                            }
                    )
                    .padding()
                } else if weatherVM.weatherModel != nil {
                    ScrollView(showsIndicators: false) {
                        ZStack(alignment: .top) {
                            VStack {
                                WeatherTopView(weatherVM: weatherVM)
                                WeatherGridView(weatherVM: weatherVM)
                            }
                            ActionButtonsView(weatherVM: weatherVM, showAlert: $showAlert)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .overlay(
            LocationUpdateAlertView(weatherVM: weatherVM, showAlert: $showAlert, searchText: $searchText, keyboardHeight: $keyboardHeight)
        )
        .onAppear {
            if weatherVM.cityName == nil {
                weatherVM.fetchData(currentLocation: true)
            } else {
                weatherVM.fetchData()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    WeatherDetailContainerView(weatherVM: WeatherViewModel(cityName: "Hudson"))
}
