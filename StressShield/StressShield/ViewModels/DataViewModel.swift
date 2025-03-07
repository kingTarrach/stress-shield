//
//  StressDataViewModel.swift
//  StressShield
//
//  Created by Austin Tarrach on 3/2/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// Sample view model to provide stress data
class DataViewModel<T: HealthData>: ObservableObject {
    // Potentially useless
    //@Published var stressData: [Stress] = []
    //@Published var hrvData: [HRVAverage] = []
    //@Published var sleepData: [SleepTotal] = []
    
    //
    @Published var healthData: [T] = []
    
    private var db = Firestore.firestore()
    
    init() {
        // TEMPORARY: Generates random data for all stress data
        //generate_random_data()
    }

    func fetchData(from collection: String, timeScale: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        let currentTime = Date()
        let calendar = Calendar.current
        var startDates: [Timestamp] = []
        
        // Determine the correct time scale for the last 7 intervals
        for i in 0..<7 {
            var dateComponent: Date?
            
            if timeScale == "Day" {
                dateComponent = calendar.date(byAdding: .day, value: -i, to: currentTime)
            } else if timeScale == "Week" {
                dateComponent = calendar.date(byAdding: .weekOfYear, value: -i, to: currentTime)
            }
            
            if let dateOnly = dateComponent {
                // Remove time component by setting hour, minute, and second to 0
                let strippedDate = calendar.startOfDay(for: dateOnly)
                startDates.append(Timestamp(date: strippedDate)) // Use Firestore Timestamp
            }
        }
        
        // Query Firestore for documents within the date range
        db.collection(collection)
            .whereField("user", isEqualTo: userID)
            .whereField("date", isGreaterThanOrEqualTo: startDates.last!) // Oldest date
            .whereField("date", isLessThanOrEqualTo: startDates.first!) // Most recent date
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching \(collection) data: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found in \(collection).")
                    return
                }
                
                var fetchedData = documents.compactMap { document in
                    try? document.data(as: T.self)
                }
                
                let completeData = self.insertMissingDates(startDates: startDates, data: fetchedData)
                
                self.healthData = self.fillMissingValues(completeData)
                
                print("Fetched \(self.healthData.count) records from \(collection).")
            }
    }
    
    
    private func insertMissingDates(startDates: [Timestamp], data: [T]) -> [T] {
        var completeData: [T] = []

        for timestamp in startDates {
            if let existingData = data.first(where: {
                guard let existingDate = $0.date else { return false }
                return Calendar.current.isDate(existingDate.dateValue(), inSameDayAs: timestamp.dateValue())
            }) {
                completeData.append(existingData) // Use existing data
            } else {
                // Insert missing date with nil value
                let missingData = createMissingDataInstance(for: timestamp)
                completeData.append(missingData)
            }
        }

        return completeData
    }

    // Create a missing data instance with nil value
    private func createMissingDataInstance(for date: Timestamp) -> T {
        // Ensure T can be initialized with default values
        guard var instance = createInstance(of: T.self) else {
            fatalError("Could not create missing data instance.")
        }

        instance.value = nil
        instance.date = date  // Assign Firestore Timestamp

        return instance
    }


    // Generic function to create a new instance of T dynamically
    private func createInstance<U: HealthData>(of type: U.Type) -> U? {
        if type == Stress.self {
            return Stress(name: "Missing Data", value: nil, date: nil, user: nil) as? U
        } else if type == HRVAverage.self {
            return HRVAverage(name: "Missing Data", value: nil, date: nil, user: nil) as? U
        } else if type == SleepTotal.self {
            return SleepTotal(name: "Missing Data", value: nil, date: nil, user: nil) as? U
        }
        return nil
    }

    // Function to fill missing values
    private func fillMissingValues(_ data: [T]) -> [T] {
        guard !data.isEmpty else { return [] }

        var filledData = data
        let count = filledData.count

        for i in 0..<count { // Iterate backwards
            if filledData[i].value == nil { // Check if missing
                filledData[i].value = 0     // Set to 0
            }
        }

        return filledData
    }
    
    
}
