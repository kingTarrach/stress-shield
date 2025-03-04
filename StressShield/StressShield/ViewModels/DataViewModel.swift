//
//  StressDataViewModel.swift
//  StressShield
//
//  Created by Austin Tarrach on 3/2/25.
//

import Foundation

// Sample view model to provide stress data
class DataViewModel: ObservableObject {
    @Published var stressData: [UserStressData] = []
    @Published var hrvData: [UserHRVData] = []
    @Published var sleepData: [UserSleepData] = []
    
    init() {
        // Populate with sample data
        let calendar = Calendar.current
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
                
                let stressLevel = Int.random(in: 0...100)
                let heartRate = Int.random(in: 60...100)
                let sleepHours = Double.random(in: 4.0...9.0)
                
                stressData.append(UserStressData(date: date, stressLevel: stressLevel))
                hrvData.append(UserHRVData(date: date, heartRate: heartRate))
                sleepData.append(UserSleepData(date: date, sleepHours: sleepHours))
                
            }
        }
        
        // Ensure data is sorted by date
        stressData.sort { $0.date < $1.date }
        hrvData.sort { $0.date < $1.date }
        sleepData.sort { $0.date < $1.date }
    }
}
