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
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.shortHandFormatE_MMM_d
    }
    
    static var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.timeFormath_mm_a
    }
    
    static var numberFormmater: NumberFormatter {
        let numberFormatter = NumberFormatter()
        return numberFormatter.wholeNumber
    }
    
}
