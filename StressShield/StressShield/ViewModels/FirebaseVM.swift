import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FirebaseVM: ObservableObject {
    
    let model = FirebaseTools()

    
    func addTest() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        print(userId)
        Task {
            let documents = await model.getCollectionFromFirestore(collection: "HRVAverage", as: HRVAverage.self, userID: userId)
            if let hrvAverages = documents {
                for hrv in hrvAverages {
                    print("Name: \(hrv.name), Value: \(hrv.value ?? 0), Date: \(hrv.date ?? Timestamp(date: Date())), User: \(hrv.user ?? "Unknown")")
                }
            } else {
                print("No HRVAverage data available.")
            }
        }
    }
}
