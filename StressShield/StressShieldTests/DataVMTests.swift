//
//  DataVMTesting.swift
//  StressShield
//
//  Created by Austin Tarrach on 4/13/25.
//

import XCTest
@testable import StressShield
import FirebaseFirestore

// MARK: - Mock Model for Testing

struct MockHealthData: HealthData {
    var name: String?
    var value: Double?
    var date: Timestamp?
    var user: String?
}

// MARK: - Unit Tests

final class DataViewModelTests: XCTestCase {

    // MARK: - Tests

    func test_fillMissingValues_allMissing_shouldFillWithFirstNonNil() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(name: "Day 1", value: nil, date: nil, user: nil),
            MockHealthData(name: "Day 2", value: nil, date: nil, user: nil),
            MockHealthData(name: "Day 3", value: 30.0, date: nil, user: nil),
            MockHealthData(name: "Day 4", value: nil, date: nil, user: nil)
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[0].value, 30.0)
        XCTAssertEqual(filled[1].value, 30.0)
        XCTAssertEqual(filled[2].value, 30.0)
        XCTAssertEqual(filled[3].value, 30.0)
    }

    func test_fillMissingValues_middleMissing_shouldAverageNeighbors() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(name: "Day 1", value: 20.0, date: nil, user: nil),
            MockHealthData(name: "Day 2", value: nil, date: nil, user: nil),
            MockHealthData(name: "Day 3", value: 40.0, date: nil, user: nil)
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[1].value, 30.0)
    }

    func test_fillMissingValues_firstMissing_shouldUseFirstValid() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(name: "Day 1", value: nil, date: nil, user: nil),
            MockHealthData(name: "Day 2", value: 10.0, date: nil, user: nil)
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[0].value, 10.0)
    }

    func test_fillMissingValues_lastMissing_shouldUseLastValid() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(name: "Day 1", value: 25.0, date: nil, user: nil),
            MockHealthData(name: "Day 2", value: nil, date: nil, user: nil)
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[1].value, 25.0)
    }
}
