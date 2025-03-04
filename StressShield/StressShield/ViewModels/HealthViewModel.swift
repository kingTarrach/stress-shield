import SwiftUI

class HealthViewModel: ObservableObject {
    
    private let model = HealthDataManager()
    private let firestoreService = FirestoreService()
    
    @Published var isAuthorized: Bool = false
    @Published var heartRateVariability: [UserHRVData] = []
    @Published var sleepData: [UserSleepData] = []
    @Published var stressData: [UserStressData] = []
    @Published var showAuthorizationPrompt: Bool = false
    
    // Temporary userID for development purposes only
    private let userId = "user123"
    
    // Check authorization and fetch data if authorized
    //    func checkAuthorizationAndFetchData() {
    //        model.isHealthDataAuthorized { [weak self] isAuthorized in
    //            DispatchQueue.main.async {
    //                self?.isAuthorized = isAuthorized
    //                if isAuthorized {
    //                    self?.fetchHealthData()
    //                } else {
    //                    self?.showAuthorizationPrompt = true
    //                }
    //            }
    //        }
    //    }
    
    //    // Fetch health data
    //    private func fetchHealthData() {
    //        let dispatchGroup = DispatchGroup()
    //        
    //        // Fetch heart rate variability data
    //        dispatchGroup.enter()
    //        model.fetchHeartRateVariability { [weak self] data, error in
    //            if let data = data {
    //                DispatchQueue.main.async {
    //                    self?.heartRateVariability = data
    //                }
    //            }
    //            dispatchGroup.leave()
    //        }
    //        
    //        // Fetch sleep data
    //        dispatchGroup.enter()
    //        model.fetchSleepData { [weak self] data, error in
    //            if let data = data {
    //                DispatchQueue.main.async {
    //                    self?.sleepData = data
    //                }
    //            }
    //            dispatchGroup.leave()
    //        }
    //        
    //        // Notify completion
    //        dispatchGroup.notify(queue: .main) {
    //            print("Fetched all health data.")
    //        }
    
    // NEED: Implement Saving to the Firebase
    //}
    
    //    private let healthDataManager = HealthDataManager()
    //    
    //    var onHealthDataUpdated: (() -> Void)?
    //    var onAuthorizationRequired: (() -> Void)?
    //    
    //    private(set) var heartRateVariability: [String: Double] = [:]
    //    private(set) var sleepData: [String: Double] = [:]
    //    
    //    // Check authorization and fetch data if authorized
    //        func checkAuthorizationAndFetchData() {
    //            healthDataManager.isHealthDataAuthorized { [weak self] isAuthorized in
    //                if isAuthorized {
    //                    self?.fetchHealthData()
    //                } else {
    //                    self?.onAuthorizationRequired?()
    //                }
    //            }
    //        }
    //    
    //    // Fetch health data
    //        private func fetchHealthData() {
    //            let dispatchGroup = DispatchGroup()
    //            
    //            // Fetch heart rate variability data
    //            dispatchGroup.enter()
    //            healthDataManager.fetchHeartRateVariability { [weak self] data, error in
    //                if let data = data {
    //                    self?.heartRateVariability = data
    //                }
    //                dispatchGroup.leave()
    //            }
    //            
    //            // Fetch sleep data
    //            dispatchGroup.enter()
    //            healthDataManager.fetchSleepData { [weak self] data, error in
    //                if let data = data {
    //                    self?.sleepData = data
    //                }
    //                dispatchGroup.leave()
    //            }
    //            
    //            // Notify the view when data is ready
    //            dispatchGroup.notify(queue: .main) { [weak self] in
    //                self?.onHealthDataUpdated?()
    //            }
    //        }
    
    //    // Fetch Health Data
    //    func fetchHealthData(completion: @escaping (Error?) -> Void) {
    //        healthDataManager.isHealthDataAuthorized { [weak self] isAuthorized in
    //            guard isAuthorized else {
    //                completion(NSError(domain: "HealthViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data access not authorized."]))
    //                return
    //            }
    //            
    //            // Fetch HRV Data
    //            self?.healthDataManager.fetchHeartRateVariability { hrvData, error in
    //                if let error = error {
    //                    completion(error)
    //                    return
    //                }
    //                // Process HRV Data (Averaging by day)
    //                self?.heartRateVariabilityDataAveraged = self?.averageHeartRateVariability(data: hrvData ?? [:]) ?? [:]
    //                
    //                // Fetch Sleep Data
    //                self?.healthDataManager.fetchSleepData { sleepData, error in
    //                    if let error = error {
    //                        completion(error)
    //                        return
    //                    }
    //                    // Process Sleep Data (Summing by day)
    //                    // self?.sleepDataPerDay = self?.summarizeSleepDuration(sleepData: sleepData ?? [:]) ?? [:]
    //                    completion(nil)
    //                }
    //            }
    //        }
    //    }
    //
    //    // Method to average HRV data
    //    func averageHeartRateVariability(data: [String: Double]) -> [String: Double] {
    //        var averagedData: [String: (total: Double, count: Int)] = [:]
    //        
    //        // Iterate through the data
    //        for (date, value) in data {
    //            if let existing = averagedData[date] {
    //                averagedData[date] = (total: existing.total + value, count: existing.count + 1)
    //            } else {
    //                averagedData[date] = (total: value, count: 1)
    //            }
    //        }
    //        
    //        var result: [String: Double] = [:]
    //        for (date, totalCount) in averagedData {
    //            let average = totalCount.total / Double(totalCount.count)
    //            result[date] = average
    //        }
    //        
    //        return result
    //    }
    
    // // Method to summarize sleep data by day
    // func summarizeSleepDuration(sleepData: [String: String]) -> [String: Double] {
    //     var sleepDurationByDate: [String: Double] = [:]
    //     var currentSleepStart: Date?
    
    //     let dateFormatter = DateFormatter()
    //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    //     // Process the sleep data
    //     for (dateTimeString, sleepStatus) in sleepData {
    //         guard let dateTime = dateFormatter.date(from: dateTimeString) else { continue }
    //         let dateKey = dateFormatter.string(from: dateTime).prefix(10) // Extract the date part
    
    //         if sleepStatus == "Asleep" {
    //             currentSleepStart = dateTime
    //         } else if sleepStatus == "Not asleep", let sleepStart = currentSleepStart {
    //             let duration = dateTime.timeIntervalSince(sleepStart) // Duration in seconds
    //             let dateKeyString = String(dateKey) // Convert to string to use as dictionary key
    //             sleepDurationByDate[dateKeyString, default: 0.0] += duration / 3600.0 // Convert seconds to hours
    //             currentSleepStart = nil
    //         }
    //     }
    
    //     return sleepDurationByDate
    // }
}
