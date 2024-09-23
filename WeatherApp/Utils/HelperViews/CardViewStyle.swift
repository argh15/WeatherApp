//
//  CardViewStyle.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct CardViewStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
            configuration.content
        }
        .frame(height: Constants.ViewDimensions.weatherDetailCardViewHeight)
        .padding()
        .background(Color(.init(white: 1.0, alpha: 0.2)), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BannerViewStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
            configuration.content
        }
        .padding()
        .background(Color(.init(white: 1.0, alpha: 0.2)), in: RoundedRectangle(cornerRadius: 12))
    }
}
