//
//  WindCardView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct WindCardView: View {
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        GroupBox(label: Label("Wind", systemImage: "wind")) {
            HStack {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        Text(weatherVM.windSpeed)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("MPH")
                                .font(.caption)
                            Text("Wind")
                                .font(.caption)
                        }
                    }
                    Rectangle()
                        .fill(.secondary)
                        .frame(width: 100, height: 1)
                        .padding(.vertical, 8)
                    HStack {
                        Text(weatherVM.gustSpeed)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("MPH")
                                .font(.caption)
                            Text("Gusts")
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .rotationEffect(Angle(degrees: weatherVM.windDirectionDeg))
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(weatherVM.windDirection)
                            .font(.title)
                        Text("Wind")
                            .font(.caption2)
                        Text("Direction")
                            .font(.caption2)
                    }
                }
            }
        }
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
    }
}

#Preview {
    WindCardView(weatherVM: WeatherViewModel())
}
