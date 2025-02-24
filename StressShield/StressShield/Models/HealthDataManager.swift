import FirebaseFirestore
import FirebaseAuth
import Foundation
import HealthKit

class HealthDataManager: ObservableObject {
    static let shared = HealthDataManager() // Singleton instance
    private let healthStore = HKHealthStore()
    private let firestoreService = FirestoreService() // Create an instance of FirestoreService
    
    // MARK: - Request HealthKit Permissions
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let dataTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
            completion(success)
        }
    }
    
    // MARK: - Enable Background Delivery
    func enableBackgroundDelivery() {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }

        healthStore.enableBackgroundDelivery(for: hrvType, frequency: .immediate) { success, error in
            if success {
                print("Enabled background delivery for HRV")
                self.startObserver(for: hrvType)
            } else {
                print("Failed to enable background delivery: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // MARK: - Observer Query (Triggers Fetch on New Data)
    private func startObserver(for type: HKSampleType) {
        let query = HKObserverQuery(sampleType: type, predicate: nil) { _, completionHandler, error in
            if let error = error {
                print("Error observing \(type.identifier): \(error.localizedDescription)")
                return
            }

            print("New \(type.identifier) data detected!")

            DispatchQueue.global(qos: .background).async {
                let userId = Auth.auth().currentUser?.uid ?? "unknown_user"
                
                if type == HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
                    self.fetchHeartRateVariability { data, _ in
                        if let hrvData = data {
                            print("Fetched HRV data: \(hrvData)")
                            self.firestoreService.saveHRVData(userId: userId, heartRateVariability: hrvData)
                        }
                    }
                } else if type == HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
                    self.fetchSleepData { data, _ in
                        if let sleepData = data {
                            print("Fetched Sleep Data: \(data ?? [:])")
                            self.firestoreService.saveSleepData(userId: userId, sleepData: sleepData)
                        }
                    }
                }
            }

            completionHandler()
        }

        healthStore.execute(query)
    }
    
    /*
    func fetchHeartRateVariability(completion: @escaping ([String: Double]?, Error?) -> Void) {
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date())
        
        let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: 1000, sortDescriptors: [sortDescriptor]) { _, results, error in
            //Dictionary with predefined HRV values for each date
            let hrvData: [String: Double] = [
                "2024-10-29": 50.0,
                "2024-10-30": 55.2,
                "2024-10-31": 60.1,
                "2024-11-01": 58.7,
                "2024-11-02": 63.3,
                "2024-11-03": 52.9,
                "2024-11-04": 59.5
            ]
            
            completion(hrvData, nil) // Return predefined dummy data without error
            
            guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
                completion(nil, NSError(domain: "HealthDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "HRV type not available"]))
                return
            }
        }
    }
    */
    
    // New heart rate variability function
    // Main change: Runs on a seperate thread as opposed to calling a view for it
    // Other changes:
    // Processes data without blocking UI
    // Returns results on main thread
    func fetchHeartRateVariability(completion: @escaping ([String: Double]?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async { // Runs in background
            let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date())

            let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: 1000, sortDescriptors: [sortDescriptor]) { _, results, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let results = results as? [HKQuantitySample] else {
                    completion(nil, nil)
                    return
                }

                var hrvData: [String: Double] = [:]
                let calendar = Calendar.current
                
                // Group by day
                let groupedByDay = Dictionary(grouping: results) { sample -> String in
                    let startOfDay = calendar.startOfDay(for: sample.startDate)
                    return self.dateString(from: startOfDay)
                }

                for (dateString, samples) in groupedByDay {
                    let hrvValues = samples.map { $0.quantity.doubleValue(for: HKUnit(from: "ms")) }
                    let dailyAverage = hrvValues.reduce(0, +) / Double(hrvValues.count)
                    hrvData[dateString] = dailyAverage
                }

                DispatchQueue.main.async { // Send result back to main thread
                    completion(hrvData, nil)
                }
            }

            self.healthStore.execute(query)
        }
    }

    
    // Check if the app has access to health data
    func isHealthDataAuthorized(completion: @escaping (Bool) -> Void) {
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        healthStore.requestAuthorization(toShare: nil, read: [hrvType, sleepType]) { success, error in
            completion(success)
        }
    }
    
    // Fetch heart rate variability data
    /*
    func fetchHeartRateVariability(completion: @escaping ([String: Double]?, Error?) -> Void) {
        
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil, NSError(domain: "HealthDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "HRV type not available"]))
            return
        }
        
        // Define the time range (last week)
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -14, to: endDate)!
        
        // Create a predicate to query samples within the time range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        // Perform the query
        let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                completion(nil, nil)
                return
            }
            
            // Process results into a dictionary of date -> average HRV
            var hrvData: [String: Double] = [:]
            
            // Group samples by local calendar day
            let groupedByDay = Dictionary(grouping: results) { sample -> String in
                let startOfDay = calendar.startOfDay(for: sample.startDate)
                return self.dateString(from: startOfDay)
            }
            
            for (dateString, samples) in groupedByDay {
                let hrvValues = samples.map { $0.quantity.doubleValue(for: HKUnit(from: "ms")) }
                let dailyAverage = hrvValues.reduce(0, +) / Double(hrvValues.count)
                hrvData[dateString] = dailyAverage
            }
            
            completion(hrvData, nil)
        }
        
        healthStore.execute(query)
    }
     */
    
    // MARK: - Fetch Sleep Data
    func fetchSleepData(completion: @escaping ([String: Double]?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
                completion(nil, NSError(domain: "HealthDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type not available"]))
                return
            }

            let calendar = Calendar.current
            let endDate = Date()
            let startDate = calendar.date(byAdding: .day, value: -14, to: endDate)!
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let results = results as? [HKCategorySample] else {
                    completion(nil, nil)
                    return
                }

                var sleepData: [String: Double] = [:]
                let groupedByDay = Dictionary(grouping: results) { sample -> String in
                    let startOfDay = calendar.startOfDay(for: sample.startDate)
                    return self.dateString(from: startOfDay)
                }

                for (dateString, samples) in groupedByDay {
                    var totalSleepDuration: Double = 0

                    for sample in samples {
                        let duration = sample.endDate.timeIntervalSince(sample.startDate)
                        totalSleepDuration += duration
                    }

                    sleepData[dateString] = totalSleepDuration / 3600.0 // Convert seconds to hours
                }

                DispatchQueue.main.async {
                    completion(sleepData, nil) // Return data to UI
                }
            }

            self.healthStore.execute(query)
        }
    }
    
    /*
    // Fetch sleep data
    func fetchSleepData(completion: @escaping ([String: Double]?, Error?) -> Void) {
        
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type not available"]))
            return
        }

        // Define the time range (last week)
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -14, to: endDate)!

        // Create a predicate to query samples within the time range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

        // Perform the query
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let self = self else { return }

            if let error = error {
                completion(nil, error)
                return
            }

            guard let results = results as? [HKCategorySample] else {
                completion(nil, nil)
                return
            }
            
            for sample in results {
                print("Sample: start=\(sample.startDate), end=\(sample.endDate), value=\(sample.value)")
            }

            // Process results into a dictionary of date -> total sleep hours
            var sleepData: [String: Double] = [:]

            // Group samples by local calendar day
            let groupedByDay = Dictionary(grouping: results) { sample -> String in
                let startOfDay = calendar.startOfDay(for: sample.startDate)
                return self.dateString(from: startOfDay)
            }

            for (dateString, samples) in groupedByDay {
                var totalSleepDuration: Double = 0

                for sample in samples {
                        let duration = sample.endDate.timeIntervalSince(sample.startDate)
                        totalSleepDuration += duration
                        print(duration)
                }

                sleepData[dateString] = totalSleepDuration / 3600.0 // Convert to hours
            }

            completion(sleepData, nil)
        }

        healthStore.execute(query)
    }
     */
    
    // Helper function to convert a date to a string format "yyyy-MM-dd"
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // Helper function to calculate the sleep duration in hours from start and end date
    private func sleepDuration(from startDate: Date, to endDate: Date) -> Double {
        let duration = endDate.timeIntervalSince(startDate)
        return duration / 3600.0 // Convert seconds to hours
    }
    
    private func calculateSampleDuration(_ sample: HKCategorySample, within range: ClosedRange<Date>) -> TimeInterval {
        let overlapStart = max(sample.startDate, range.lowerBound)
        let overlapEnd = min(sample.endDate, range.upperBound)
        return max(overlapEnd.timeIntervalSince(overlapStart), 0)
    }

}
