//
//  HealthViewModelTests.swift
//  StressShieldTests
//
//  Created by Austin Tarrach on 4/11/25.
//

import XCTest
@testable import StressShield

// MARK: - Mock Data Manager

class MockHealthDataManager: HealthDataManager {
    var shouldAuthorize = true
    var mockHRV: [String: Double] = ["2025-04-11": 55.5]
    var mockSleep: [String: Double] = ["2025-04-11": 7.0]

    override func isHealthDataAuthorized(completion: @escaping (Bool) -> Void) {
        completion(shouldAuthorize)
    }

    override func fetchHeartRateVariability(completion: @escaping ([String: Double]?, Error?) -> Void) {
        completion(mockHRV, nil)
    }

    override func fetchSleepData(completion: @escaping ([String: Double]?, Error?) -> Void) {
        completion(mockSleep, nil)
    }
}

// MARK: - Tests

final class HealthViewModelTests: XCTestCase {
    
    func testAuthorization_granted_shouldFetchData() {
        let mockManager = MockHealthDataManager()
        mockManager.shouldAuthorize = true
        let viewModel = HealthViewModel(model: mockManager)

        let expectation = XCTestExpectation(description: "Fetch data when authorized")

        viewModel.checkAuthorizationAndFetchData()

        // Dispatch to allow time for async update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(viewModel.isAuthorized)
            XCTAssertFalse(viewModel.showAuthorizationPrompt)
            XCTAssertEqual(viewModel.heartRateVariability["2025-04-11"], 55.5)
            XCTAssertEqual(viewModel.sleepData["2025-04-11"], 7.0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthorization_denied_shouldShowPrompt() {
        let mockManager = MockHealthDataManager()
        mockManager.shouldAuthorize = false
        let viewModel = HealthViewModel(model: mockManager)

        let expectation = XCTestExpectation(description: "Show prompt when unauthorized")

        viewModel.checkAuthorizationAndFetchData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(viewModel.isAuthorized)
            XCTAssertTrue(viewModel.showAuthorizationPrompt)
            XCTAssertTrue(viewModel.heartRateVariability.isEmpty)
            XCTAssertTrue(viewModel.sleepData.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
