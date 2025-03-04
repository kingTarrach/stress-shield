//
//  UserHealthData.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/28/25.
//

import Foundation

protocol ChartData: Identifiable {
    var date: Date { get }
    var value: CGFloat { get } // Generic value extraction
    static var minValue: CGFloat { get }
    static var maxValue: CGFloat { get }
}

struct UserStressData: Identifiable, ChartData {
    let id = UUID()
    let date: Date
    let stressLevel: Int
    
    var value: CGFloat { CGFloat(stressLevel) } // Use common property
    
    // Min/Max
    static let minValue: CGFloat = 0
    static let maxValue: CGFloat = 100
}

struct UserHRVData: Identifiable, ChartData {
    let id = UUID()
    let date: Date
    let heartRate: Int

    var value: CGFloat { CGFloat(heartRate) }
    
    // Min/Max
    static let minValue: CGFloat = 40
    static let maxValue: CGFloat = 200
}

struct UserSleepData: Identifiable, ChartData {
    let id = UUID()
    let date: Date
    let sleepHours: Double

    var value: CGFloat { CGFloat(sleepHours) }
    
    // Min/Max
    static let minValue: CGFloat = 0
    static let maxValue: CGFloat = 10
}
