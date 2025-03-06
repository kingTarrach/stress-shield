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
                
                self.healthData = documents.compactMap { document in
                    do {
                        return try document.data(as: T.self)
                    } catch {
                        print("Error decoding document \(document.documentID): \(error)")
                        return nil
                    }
                }
                
                print("Fetched \(self.healthData.count) records from \(collection).")
            }
    }



    
//    private func generate_random_data() {
//        // Populate with sample data
//        let calendar = Calendar.current
//        for day in 0..<7 {
//            if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
//                
//                let stressLevel = Int.random(in: 0...100)
//                let heartRate = Int.random(in: 60...100)
//                let sleepHours = Double.random(in: 4.0...9.0)
//                
//                stressData.append(Stress(date: date, stressLevel: stressLevel))
//                hrvData.append(UserHRVData(date: date, heartRate: heartRate))
//                sleepData.append(UserSleepData(date: date, sleepHours: sleepHours))
//                
//            }
//        }
//        
//        // Ensure data is sorted by date
//        stressData.sort { $0.date < $1.date }
//        hrvData.sort { $0.date < $1.date }
//        sleepData.sort { $0.date < $1.date }
//    }
}
