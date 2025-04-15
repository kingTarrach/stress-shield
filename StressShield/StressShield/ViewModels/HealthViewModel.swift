import SwiftUI

class HealthViewModel: ObservableObject {
    
    private var model = HealthDataManager()
    
    init(model: HealthDataManager = HealthDataManager()) {
        self.model = model
    }
        
        @Published var isAuthorized: Bool = false
        @Published var heartRateVariability: [String: Double] = [:]
        @Published var sleepData: [String: Double] = [:]
        @Published var showAuthorizationPrompt: Bool = false
        
        // Check authorization and fetch data if authorized
        func checkAuthorizationAndFetchData() {
            model.isHealthDataAuthorized { [weak self] isAuthorized in
                DispatchQueue.main.async {
                    self?.isAuthorized = isAuthorized
                    if isAuthorized {
                        self?.fetchHealthData()
                    } else {
                        self?.showAuthorizationPrompt = true
                    }
                }
            }
        }
        
        // Fetch health data
        private func fetchHealthData() {
            let dispatchGroup = DispatchGroup()
            
            // Fetch heart rate variability data
            dispatchGroup.enter()
            model.fetchHeartRateVariability { [weak self] data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.heartRateVariability = data
                    }
                }
                dispatchGroup.leave()
            }
            
            // Fetch sleep data
            dispatchGroup.enter()
            model.fetchSleepData { [weak self] data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.sleepData = data
                    }
                }
                dispatchGroup.leave()
            }
            
            // Notify completion
            dispatchGroup.notify(queue: .main) {
                print("Fetched all health data.")
            }
        }
}
