//
//  ActionButtonsView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct ActionButtonsView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    @Binding var showAlert: Bool
    
    var body: some View {
        HStack {
            Button(action: { weatherVM.fetchData(currentLocation: true) }) {
                Text("Reset")
                    .navStyleButton()
            }
            Spacer()
            Button(action: { showAlert.toggle() }) {
                Text("Edit")
                    .navStyleButton()
            }
        }
        .padding(.top, 16)
    }
}

extension View {
    func navStyleButton() -> some View {
        self
            .font(.system(size: 17, weight: .medium))
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(Color(.init(white: 1.0, alpha: 0.3)))
            .foregroundColor(.white)
            .cornerRadius(5)
    }
}
