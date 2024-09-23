//
//  SunCycleCardView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct SunCycleCardView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        GroupBox {
            HStack {
                Label(weatherVM.sunrise, systemImage: "sunrise.fill")
                    .font(.callout)
                
                Spacer()
                
                Label(weatherVM.sunset, systemImage: "sunset.fill")
                    .font(.callout)
            }
        }
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.bannerView)
    }
}

#Preview {
    SunCycleCardView(weatherVM: WeatherViewModel())
}
