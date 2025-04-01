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
        print("Generating Health Data")
        
        var hrvAverages: [HRVAverage] = []
        var stressLevels: [Stress] = []
        var sleepTotals: [SleepTotal] = []
        let dates: [Double] = [1, 2, 4, 6, 7]
        for date in dates {
            var daysAgo = Calendar.current.date(byAdding: .day, value: Int(-date), to: Date())!
            var firebaseTimestamp = Timestamp(date: daysAgo)
            hrvAverages.append(HRVAverage(name: "HRV", value: Double.random(in: 40...70), date: firebaseTimestamp, user: userId))
            stressLevels.append(Stress(name: "Stress", value: Double.random(in: 20...75), date: firebaseTimestamp, user: userId))
            sleepTotals.append(SleepTotal(name: "Sleep", value: Double.random(in: 6...8.5), date: firebaseTimestamp, user: userId))
        }
        
        Task {
            for hrvAverage in hrvAverages {
                await model.addDocumentToFirestore(collection: "HRVAverage", document: hrvAverage)
            }
            for stressLevel in stressLevels {
                await model.addDocumentToFirestore(collection: "Stress", document: stressLevel)
            }
            for sleepTotal in sleepTotals {
                await model.addDocumentToFirestore(collection: "SleepTotal", document: sleepTotal)
            }
        }
    }
}
