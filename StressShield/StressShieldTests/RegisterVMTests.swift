//
//  RegisterViewVMTests.swift
//  StressShieldTests
//
//  Created by Austin Tarrach on 4/13/25.
//

import XCTest
@testable import StressShield

final class RegisterVMTests: XCTestCase {

    func test_validate_allFieldsEmpty_shouldFail() {
        let vm = RegisterViewVM()
        let isValid = vm.validate()
        XCTAssertFalse(isValid)
        XCTAssertEqual(vm.errorMsg, "Please fill in all fields.")
    }

    func test_validate_invalidEmail_shouldFail() {
        let vm = RegisterViewVM()
        vm.firstName = "Jane"
        vm.lastName = "Doe"
        vm.email = "jane_at_email" // invalid
        vm.password = "password123"
        vm.confirmPassword = "password123"

        let isValid = vm.validate()
        XCTAssertFalse(isValid)
        XCTAssertEqual(vm.errorMsg, "Please enter valid email.")
    }

    func test_validate_shortPassword_shouldFail() {
        let vm = RegisterViewVM()
        vm.firstName = "John"
        vm.lastName = "Smith"
        vm.email = "john@example.com"
        vm.password = "123"
        vm.confirmPassword = "123"

        let isValid = vm.validate()
        XCTAssertFalse(isValid)
        XCTAssertEqual(vm.errorMsg, "Password must be at least 6 characters long.")
    }

    func test_validate_mismatchedPasswords_shouldFail() {
        let vm = RegisterViewVM()
        vm.firstName = "Alice"
        vm.lastName = "Wonder"
        vm.email = "alice@wonderland.com"
        vm.password = "password123"
        vm.confirmPassword = "password321"

        let isValid = vm.validate()
        XCTAssertFalse(isValid)
        XCTAssertEqual(vm.errorMsg, "Passwords do not match.")
    }

    func test_validate_validInput_shouldPass() {
        let vm = RegisterViewVM()
        vm.firstName = "Bob"
        vm.lastName = "Builder"
        vm.email = "bob@build.com"
        vm.password = "builder123"
        vm.confirmPassword = "builder123"

        let isValid = vm.validate()
        XCTAssertTrue(isValid)
        XCTAssertEqual(vm.errorMsg, "") // No error message
    }
}
