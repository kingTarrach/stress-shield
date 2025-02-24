//
//  BackgroundTaskManager.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/18/25.
//

import Foundation

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private var timer: Timer?

    private init() {}

    func startMonitoring() {
        print("Starting background health data monitoring...")

        // Enable HealthKit background fetch
        HealthDataManager.shared.enableBackgroundDelivery()

        // Optional: Run additional periodic tasks
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            DispatchQueue.global(qos: .background).async {
                HealthDataManager.shared.fetchHeartRateVariability { data, error in
                    if let error = error {
                        print("Error fetching HRV: \(error.localizedDescription)")
                        return
                    }

                    if let data = data {
                        print("Fetched background HRV data: \(data)")
                        // Save to Core Data / UserDefaults if needed
                    }
                }
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
    }
}
