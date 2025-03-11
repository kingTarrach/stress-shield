import Foundation

class HealthViewModel: ObservableObject {
    private let healthDataManager = HealthDataManager()
    
    @Published var heartRateVariabilityDataAveraged: [String: Double] = [:]
    @Published var sleepDataPerDay: [String: Double] = [:]
    
    // Fetch Health Data
    func fetchHealthData(completion: @escaping (Error?) -> Void) {
        healthDataManager.isHealthDataAuthorized { [weak self] isAuthorized in
            guard isAuthorized else {
                completion(NSError(domain: "HealthViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data access not authorized."]))
                return
            }
            
            // Fetch HRV Data
            self?.healthDataManager.fetchHeartRateVariability { hrvData, error in
                if let error = error {
                    completion(error)
                    return
                }
                // Process HRV Data (Averaging by day)
                self?.heartRateVariabilityDataAveraged = self?.averageHeartRateVariability(data: hrvData ?? [:]) ?? [:]
                
                // Fetch Sleep Data
                self?.healthDataManager.fetchSleepData { sleepData, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    // Process Sleep Data (Summing by day)
                    //self?.sleepDataPerDay = self?.summarizeSleepDuration(sleepData: sleepData ?? [:]) ?? [:]
                    completion(nil)
                }
            }
        }
    }

    // Method to average HRV data
    func averageHeartRateVariability(data: [String: Double]) -> [String: Double] {
        var averagedData: [String: (total: Double, count: Int)] = [:]
        
        // Iterate through the data
        for (date, value) in data {
            if let existing = averagedData[date] {
                averagedData[date] = (total: existing.total + value, count: existing.count + 1)
            } else {
                averagedData[date] = (total: value, count: 1)
            }
        }
        
        var result: [String: Double] = [:]
        for (date, totalCount) in averagedData {
            let average = totalCount.total / Double(totalCount.count)
            result[date] = average
        }
        
        return result
    }

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