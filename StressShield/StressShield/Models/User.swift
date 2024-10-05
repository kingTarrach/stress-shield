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
}
