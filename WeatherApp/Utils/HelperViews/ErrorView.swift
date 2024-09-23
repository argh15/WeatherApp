//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/22/24.
//

import SwiftUI

struct ErrorView: View {
    var errorImage: Image
    var errorTitle: String
    var errorDescription: String
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Error Image
            errorImage
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(Helpers.isNight ? .white : .black)
            
            // Error Title
            Text(errorTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Helpers.isNight ? .white : .black)
            
            // Error Description
            Text(errorDescription)
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(Helpers.isNight ? .white : .black)
                .padding()
                .cornerRadius(12)
            
            Button(action: {
                onRetry()  // Execute the retry closure
            }) {
                Text("Retry")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color(.init(white: 1.0, alpha: 0.3)))
                    .cornerRadius(8)
            }
        }
        .padding()
        .padding(.horizontal, 32)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            errorImage: Image(systemName: "exclamationmark.triangle.fill"),
            errorTitle: "Network Error",
            errorDescription: "Unable to fetch weather data. Please check your connection and try again.", onRetry: {
                print("Retry Clicked")
            }
        )
    }
}

