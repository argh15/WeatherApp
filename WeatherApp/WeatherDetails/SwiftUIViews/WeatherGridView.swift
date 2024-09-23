//
//  WeatherGridView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct WeatherGridView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        VStack {
            Text(weatherVM.date)
                .font(.caption)
                .foregroundStyle(.white)
            SunCycleCardView(weatherVM: weatherVM)
            HStack {
                WindCardView(weatherVM: weatherVM)
            }
            HStack {
                GenericCardView(label: "Humidity", imageName: "humidity", primaryValue: weatherVM.humidity, description: weatherVM.humidityVerbiage)
                GenericCardView(label: "Feels Like", imageName: "thermometer", primaryValue: weatherVM.feelsLike, description: weatherVM.feelsLikeVerbiage)
            }
            HStack {
                GenericCardView(label: "Clouds", imageName: "cloud", primaryValue: weatherVM.clouds, description: weatherVM.cloudsVerbiage)
                GenericCardView(label: "Visibility", imageName: "eye", primaryValue: weatherVM.visibility, description: weatherVM.visibilityVerbiage)
            }
        }
    }
}

#Preview {
    WeatherGridView(weatherVM: WeatherViewModel())
}
