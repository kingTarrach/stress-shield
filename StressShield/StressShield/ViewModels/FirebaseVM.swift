import Foundation
import SwiftUI
import FirebaseAuth


class FirebaseVM: ObservableObject {
    
    let model = FirebaseTools()

    
    func addTest() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        Task {
            let test = HRVAverage(name: "Test1", value: 100, date: Date().timeIntervalSince1970, user: "Test User")
            let test2: [String: Any] = ["name": "Test2", "value": 100, "date": Date().timeIntervalSince1970, "user": "Test User"]
            await model.addDocumentToFirestore(collection: "HRVAverage", document: test)
            await model.addDocumentToFirestore(collection:"HRVAverage", documentFields: test2)
        }
    }
}
