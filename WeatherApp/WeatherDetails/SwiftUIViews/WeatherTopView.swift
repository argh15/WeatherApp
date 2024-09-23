//
//  WeatherTopView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct WeatherTopView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(weatherVM.location)
                .font(.headline)
                .padding(.top, 16)
            CacheAsyncImage(url: weatherVM.weatherModel?.weather?.first?.iconURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipped()
                } else if case .empty = phase {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }
            }
            Text(weatherVM.currentTemp)
                .font(.largeTitle)
            Text(weatherVM.overview)
                .font(.caption)
            HStack {
                Text(weatherVM.highTemp)
                    .font(.caption)
                Text(weatherVM.lowTemp)
                    .font(.caption)
            }
            if weatherVM.isRainSnowDataPresent {
                Text(weatherVM.rainOrSnowPrecipitation)
                    .font(.title3)
            }
        }
        .foregroundStyle(.white)
        .padding(.bottom, 40)
    }
}

#Preview {
    WeatherTopView(weatherVM: WeatherViewModel())
}
