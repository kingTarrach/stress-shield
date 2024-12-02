//
//  User.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    
    // Computed property to format joined date
    var joinDateFormatted: String {
        let date = Date(timeIntervalSince1970: joined) // Convert TimeInterval to Date
        let formatter = DateFormatter()
        formatter.dateStyle = .long // e.g., "August 25, 2024"
        return formatter.string(from: date)
    }
}
