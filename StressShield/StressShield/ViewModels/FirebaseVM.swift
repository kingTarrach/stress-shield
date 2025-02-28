import Foundation
import SwiftUI


class FirebaseVM: ObservableObject {
    
    let model = FirebaseTools()
    let test = HRVAverage(name: "Test1", value: 100, date: Date().timeIntervalSince1970, user: "Test User")
    let test2: [String: Any] = ["name": "Test2", "value": 100, "date": Date().timeIntervalSince1970, "user": "Test User"]
    
    func addTest() {
        model.addDocumentToFirestore(collection: "HRVAverage", document: test)
        model.addDocumentToFirestore(collection:"HRVAverage", documentFields: test2)
    }
}
