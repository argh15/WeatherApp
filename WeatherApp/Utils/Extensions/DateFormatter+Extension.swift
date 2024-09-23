//
//  DateFormatter+Extension.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/21/24.
//

import Foundation

extension DateFormatter {
    
    var shortHandFormatE_MMM_d: DateFormatter {
        self.dateFormat = "E, MMM, d"
        return self
    }
    
    var timeFormath_mm_a: DateFormatter {
        self.dateFormat = "h:mm a"
        return self
    }
}
