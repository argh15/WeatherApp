//
//  WeatherModelTests.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import XCTest
@testable import WeatherApp

final class WeatherModelTests: XCTestCase {
    
    func testExample() throws {
        let jsonData = """
            {
                "weather": [
                    {
                        "id": 800,
                        "main": "Clear",
                        "description": "clear sky",
                        "icon": "01d"
                    }
                ],
                "main": {
                    "temp": 25.0,
                    "feels_like": 24.0,
                    "temp_min": 23.0,
                    "temp_max": 27.0,
                    "pressure": 1012,
                    "humidity": 60
                },
                "visibility": 10000,
                "wind": {
                    "speed": 5.0,
                    "deg": 270
                },
                "rain": {
                    "1h": 0.0
                },
                "snow": {
                    "1h": 0.0
                },
                "clouds": {
                    "all": 0
                },
                "dt": 1609459200,
                "sys": {
                    "sunrise": 1609430400,
                    "sunset": 1609473600
                },
                "name": "Test City"
            }
            """.data(using: .utf8)!
        do {
            // Attempt to decode the JSON data into WeatherModel
            let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: jsonData)
            XCTAssertNotNil(weatherModel, "WeatherModel should not be nil after decoding")
            XCTAssertEqual(weatherModel.name, "Test City", "City name should match")
            XCTAssertEqual(weatherModel.main?.temp, 25.0, "Temperature should match")
            XCTAssertEqual(weatherModel.weather?.first?.description, "clear sky", "Weather description should match")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testWeatherModelEncoding() throws {
        // Create a sample WeatherModel for encoding
        let weather = Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")
        let main = Main(temp: 25.0, feelsLike: 24.0, tempMin: 23.0, tempMax: 27.0, pressure: 1012, humidity: 60)
        let wind = Wind(speed: 5.0, deg: 270, gust: nil)
        let clouds = Clouds(all: 0)
        let sys = Sys(sunrise: Date(timeIntervalSince1970: 1609430400), sunset: Date(timeIntervalSince1970: 1609473600))
        
        let weatherModel = WeatherModel(weather: [weather], main: main, visibility: 10000, wind: wind, rain: nil, snow: nil, clouds: clouds, dt: Date(timeIntervalSince1970: 1609459200), sys: sys, name: "Test City")
        
        do {
            // Attempt to encode the WeatherModel back to JSON data
            let jsonData = try JSONEncoder().encode(weatherModel)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            // Print the JSON string for debugging
            print("Encoded JSON: \(jsonString ?? "")")
            
            XCTAssertNotNil(jsonString, "Encoded JSON string should not be nil")
            XCTAssert(jsonString!.contains("\"name\":\"Test City\""), "Encoded JSON should contain city name")
            XCTAssert(jsonString!.contains("\"temp\":25"), "Encoded JSON should contain temperature")
        } catch {
            XCTFail("Encoding failed with error: \(error)")
        }
    }
    
}
