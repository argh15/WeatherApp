//
//  GroupStyle+Extension.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import SwiftUI

extension GroupBoxStyle where Self == CardViewStyle {
    static var cardView: CardViewStyle { .init() }
}

extension GroupBoxStyle where Self == BannerViewStyle {
    static var bannerView: BannerViewStyle { .init() }
}
