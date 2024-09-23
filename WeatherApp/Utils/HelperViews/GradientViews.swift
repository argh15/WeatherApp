//
//  GradientViews.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct DayGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.6, blue: 0.9),
                Color(red: 0.9, green: 0.85, blue: 0.5)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct NightGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.0, green: 0.0, blue: 0.1),
                Color(red: 0.1, green: 0.1, blue: 0.4)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    DayGradientView()
}
