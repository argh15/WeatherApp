//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import XCTest
@testable import WeatherApp

final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockLocationService: MockLocationService!
    var mockAPIService: MockAPIService!
    
    override func setUpWithError() throws {
        super.setUp()
        mockLocationService = MockLocationService()
        mockAPIService = MockAPIService()
        viewModel = WeatherViewModel(cityName: "San Francisco", apiService: mockAPIService, locationService: mockLocationService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockLocationService = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertNil(viewModel.weatherModel, "Initial weatherModel should be nil")
        XCTAssertNil(viewModel.errorMessage, "Initial errorMessage should be nil")
        XCTAssertFalse(viewModel.isLoading, "Initial loading state should be false")
    }
    
    func testFetchDataWithValidCityName() {
        let expectation = self.expectation(description: "Fetch weather data for a valid city")
        
        // Mock API response
        mockAPIService.mockWeatherData = WeatherModel(
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            main: Main(temp: 25.0, feelsLike: 24.0, tempMin: 23.0, tempMax: 27.0, pressure: 1012, humidity: 60),
            visibility: 10000,
            wind: Wind(speed: 5.0, deg: 270, gust: 19.2),
            rain: nil,
            snow: nil,
            clouds: Clouds(all: 0),
            dt: Date(),
            sys: Sys(sunrise: Date(), sunset: Date()),
            name: "San Francisco"
        )
        
        // Mock location coordinates
        mockLocationService.mockGetCoordinatesResult = .success((37.7749, -122.4194))
        
        viewModel.fetchData(currentLocation: false) // Assuming cityName is set
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Add a delay for async calls
            XCTAssertNotNil(self.viewModel.weatherModel, "weatherModel should not be nil after fetching data")
            XCTAssertNil(self.viewModel.errorMessage, "errorMessage should be nil after successful fetch")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after fetch")
            XCTAssertEqual(self.viewModel.weatherModel?.name, "San Francisco", "Fetched city name should match")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    
    
    func testFetchDataWithInvalidCityName() {
        let expectation = self.expectation(description: "Fetch weather data for an invalid city")
        
        // Simulate an invalid city name
        viewModel.cityName = "InvalidCityName"
        
        // Mock the response from location service
        mockLocationService.mockGetCoordinatesResult = .failure(.error("Invalid city"))
        
        viewModel.fetchData(currentLocation: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNil(self.viewModel.weatherModel, "weatherModel should be nil for an invalid city")
            XCTAssertEqual(self.viewModel.errorMessage, "Error fetching coordinates: Invalid City", "Should return the correct error message")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after failure")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    
    func testFetchDataWithCurrentLocation() {
        let expectation = self.expectation(description: "Fetch weather data for current location")
        
        // Mock location service to return valid coordinates for current location
        mockLocationService.mockGetCoordinatesResult = .success((37.7749, -122.4194))  // Coordinates for San Francisco
        
        viewModel.fetchData(currentLocation: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewModel.weatherModel, "weatherModel should not be nil after fetching data")
            XCTAssertNil(self.viewModel.errorMessage, "errorMessage should be nil after successful fetch")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after fetch")
            XCTAssertEqual(self.viewModel.weatherModel?.name, "San Francisco", "Fetched city name should match")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    
}
