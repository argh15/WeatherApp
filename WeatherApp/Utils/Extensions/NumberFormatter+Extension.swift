//
//  NumberFormatter+Extension.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

extension NumberFormatter {
    
    var wholeNumber: NumberFormatter {
        self.maximumFractionDigits = 0
        return self
    }
}
