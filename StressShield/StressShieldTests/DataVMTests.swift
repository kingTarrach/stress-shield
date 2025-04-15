//
//  DataVMTesting.swift
//  StressShieldTests
//
//  Created by Austin Tarrach on 4/13/25.
//

import XCTest
@testable import StressShield
import FirebaseFirestore

// MARK: - Mock Model for Testing

struct MockHealthData: HealthData {
    var id: UUID
    var name: String?
    var value: Double?
    var date: Timestamp?
    var user: String?
    
    static var minValue: CGFloat { return 20.0 }
    static var maxValue: CGFloat { return 100.0 }
}

// MARK: - Unit Tests

final class DataViewModelTests: XCTestCase {

    func test_fillMissingValues_allMissing_shouldFillWithFirstNonNil() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(id: UUID(), name: "Day 1", value: nil, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 2", value: nil, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 3", value: 30.0, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 4", value: nil, date: nil, user: "TestUser")
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
            MockHealthData(id: UUID(), name: "Day 1", value: 20.0, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 2", value: nil, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 3", value: 40.0, date: nil, user: "TestUser")
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[1].value, 30.0)
    }

    func test_fillMissingValues_firstMissing_shouldUseFirstValid() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(id: UUID(), name: "Day 1", value: nil, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 2", value: 10.0, date: nil, user: "TestUser")
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[0].value, 10.0)
    }

    func test_fillMissingValues_lastMissing_shouldUseLastValid() throws {
        let viewModel = DataViewModel<MockHealthData>()

        let data: [MockHealthData] = [
            MockHealthData(id: UUID(), name: "Day 1", value: 25.0, date: nil, user: "TestUser"),
            MockHealthData(id: UUID(), name: "Day 2", value: nil, date: nil, user: "TestUser")
        ]

        let filled = viewModel.fillMissingValues(data)

        XCTAssertEqual(filled[1].value, 25.0)
    }
    
    func test_insertMissingDates_fillsMissingDaysCorrectly() {
        let viewModel = DataViewModel<MockHealthData>()

        let baseDate = Date()
        let calendar = Calendar.current
        let date1 = Timestamp(date: baseDate)
        let date2 = Timestamp(date: calendar.date(byAdding: .day, value: 1, to: baseDate)!)
        let date3 = Timestamp(date: calendar.date(byAdding: .day, value: 2, to: baseDate)!)

        // Only 2 of the 3 days have data
        let data: [MockHealthData] = [
            MockHealthData(id: UUID(), name: "Day 1", value: 20.0, date: date1, user: "u1"),
            MockHealthData(id: UUID(), name: "Day 3", value: 60.0, date: date3, user: "u1")
        ]

        let complete = viewModel.insertMissingDates(startDates: [date1, date2, date3], data: data)

        XCTAssertEqual(complete.count, 3)
        XCTAssertEqual(complete[0].value, 20.0)
        XCTAssertNil(complete[1].value) // Inserted missing day
        XCTAssertEqual(complete[2].value, 60.0)
        XCTAssertTrue(Calendar.current.isDate(complete[1].date!.dateValue(), inSameDayAs: date2.dateValue()))
    }
}
