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
        // let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        // let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        // let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date())
        
        // let query = HKSampleQuery(sampleType: hrvType, predicate: predicate, limit: 1000, sortDescriptors: [sortDescriptor]) { _, results, error in
        //     if let error = error {
        //         completion(nil, error)
        //         return
        //     }
            
        //     var hrvData: [String: [Double]] = [:] // Use an array to store multiple HRV samples per day
        //     let dateFormatter = DateFormatter()
        //     dateFormatter.dateFormat = "yyyy-MM-dd" // Standard date format
            
        //     for sample in results as! [HKQuantitySample] {
        //         let date = sample.startDate
        //         let value = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
        //         let dateString = dateFormatter.string(from: date)
                
        //         // Store multiple HRV values for each date
        //         hrvData[dateString, default: []].append(value)
        //     }
            
        //     // Now calculate the average for each date
        //     var averagedHRVData: [String: Double] = [:]
        //     for (date, values) in hrvData {
        //         let average = values.reduce(0, +) / Double(values.count)
        //         averagedHRVData[date] = average
        //     }
            
        //     completion(averagedHRVData, nil)
        // }
        
        // healthStore.execute(query)

                // Dictionary with predefined HRV values for each date
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
    }
    
    // Fetch sleep data
    func fetchSleepData(completion: @escaping ([String: Double]?, Error?) -> Void) {
        // let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        // let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        // let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date())
        
        // let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 1000, sortDescriptors: [sortDescriptor]) { _, results, error in
        //     if let error = error {
        //         completion(nil, error)
        //         return
        //     }
            
        //     var sleepData: [String: Double] = [:] // Track sleep duration by day
        //     let dateFormatter = DateFormatter()
        //     dateFormatter.dateFormat = "yyyy-MM-dd"
            
        //     for sample in results as! [HKCategorySample] {
        //         let date = sample.startDate
        //         let status = sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue ? "Asleep" : "Not asleep"
                
        //         // Only count sleep durations if the user is asleep
        //         if status == "Asleep" {
        //             let sleepStart = sample.startDate
        //             let sleepEnd = sample.endDate ?? Date()
        //             let sleepDuration = sleepEnd.timeIntervalSince(sleepStart) / 3600.0 // Convert to hours
                    
        //             let dateString = dateFormatter.string(from: sleepStart)
        //             sleepData[dateString, default: 0.0] += sleepDuration
        //         }
        //     }
            
        //     completion(sleepData, nil)
        // }
        
        // healthStore.execute(query)

        // Dictionary with predefined sleep duration for each date
        let sleepData: [String: Double] = [
            "2024-10-29": 7.5,
            "2024-10-30": 6.8,
            "2024-10-31": 7.2,
            "2024-11-01": 8.0,
            "2024-11-02": 5.5,
            "2024-11-03": 7.0,
            "2024-11-04": 6.2
        ]
        
        completion(sleepData, nil) // Return predefined dummy data without error
    }
}
