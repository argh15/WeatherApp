//
//  SearchBarView.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/22/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter city name", text: $searchText)
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.gray)
                .font(.system(size: 17))
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: {
                            onSearch()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .disabled(searchText.isEmpty)
                    }
                )
        }
        .padding(.horizontal, 10)
    }
}

