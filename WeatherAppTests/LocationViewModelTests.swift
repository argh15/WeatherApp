//
//  LocationViewModelTests.swift
//  WeatherAppTests
//
//  Created by Arghadeep Chakraborty on 9/23/24.
//

import XCTest
@testable import WeatherApp

final class LocationViewModelTests: XCTestCase {
    
    var viewModel: LocationViewModel!
    var mockCoordinator: MockCoordinator!
    var mockLocationService: MockLocationService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockCoordinator = MockCoordinator()
        mockLocationService = MockLocationService()
        viewModel = LocationViewModel(coordinator: mockCoordinator, locationService: mockLocationService)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    func testOnBoardingCompleteWithCityName() {
        let expectedCityName = "San Francisco"
        viewModel.onBoardingComplete(with: expectedCityName)
        
        XCTAssertEqual(mockCoordinator.cityName, expectedCityName, "The coordinator should receive the expected city name.")
    }
    
    func testFetchUserLocationSuccess() {
        let expectation = self.expectation(description: "Permission request should succeed")
        
        mockLocationService.mockRequestLocationResult = .success(())
        viewModel.fetchUserLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.mockCoordinator.cityName, "The coordinator should not receive a city name on success.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchUserLocationFailure() {
        let expectation = self.expectation(description: "Permission request should fail")
        
        let expectedError = CustomError.error("Location access denied")
        mockLocationService.mockRequestLocationResult = .failure(expectedError) // Mock the result
        
        viewModel.fetchUserLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoordinator.error, expectedError, "The coordinator should handle the error appropriately.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
