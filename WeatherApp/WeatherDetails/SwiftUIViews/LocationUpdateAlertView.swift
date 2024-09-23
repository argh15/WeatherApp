//
//  LocationUpdateAlertView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct LocationUpdateAlertView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    @Binding var showAlert: Bool
    @Binding var searchText: String
    @Binding var keyboardHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            if showAlert {
                ZStack {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Search City")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                        
                        SearchBarView(searchText: $searchText) {
                            weatherVM.cityName = searchText
                            weatherVM.fetchData(currentLocation: false)
                            showAlert.toggle()
                            searchText = ""
                        }
                        
                        HStack {
                            Button(action: {
                                showAlert.toggle()
                                searchText = ""
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            
                            Button(action: {
                                weatherVM.cityName = searchText
                                weatherVM.fetchData(currentLocation: false)
                                showAlert.toggle()
                                searchText = ""
                            }) {
                                Text("Search")
                                    .foregroundColor(.blue)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            .disabled(searchText.isEmpty)
                            .padding(.trailing, 8)
                        }
                        .font(.headline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .offset(y: -keyboardHeight / 2)
                    .animation(.easeInOut, value: showAlert)
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            keyboardHeight = keyboardFrame.height
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
                .onDisappear {
                    // Stop observing keyboard changes
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                }
            }
        }
    }
}
