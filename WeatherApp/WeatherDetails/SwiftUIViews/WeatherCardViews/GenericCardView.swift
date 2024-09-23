//
//  HumidityCardView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

struct GenericCardView: View {
    
    @State var label: String
    @State var imageName: String
    @State var primaryValue: String
    @State var description: String

    var body: some View {
        GroupBox(label: Label(label, systemImage: imageName)) {
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(primaryValue)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(description)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundStyle(Helpers.isNight ? .white : .black)
        .groupBoxStyle(.cardView)
    }
}

#Preview {
    GenericCardView(label: "Humidity", imageName: "humidity", primaryValue: "87%", description: "Some description about humidity")
}
