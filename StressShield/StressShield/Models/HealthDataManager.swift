import Foundation
import HealthKit

class HealthDataManager {
    private let healthStore = HKHealthStore()
    
    // Check if the app has access to health data
    func isHealthDataAuthorized(completion: @escaping (Bool) -> Void) {
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        healthStore.requestAuthorization(toShare: nil, read: [hrvType, sleepType]) { success, error in
            completion(success)
        }
    }
    
    // Fetch heart rate variability data
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
