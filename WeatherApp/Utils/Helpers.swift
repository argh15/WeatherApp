//
//  Helpers.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/22/24.
//

import Foundation

struct Helpers {
    
    static var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour < 6 || hour >= 18)
    }
}
