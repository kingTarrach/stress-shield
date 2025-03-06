//
//  FireStoreService.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/9/25.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    private let db = Firestore.firestore()

    // Save or update lesson progress
    func updateLessonProgress(userId: String, lessonId: String, status: LessonStatus, completion: @escaping (Error?) -> Void) {
        let progressRef = db.collection("users").document(userId).collection("lessonProgress")

        // Query Firestore for an existing progress entry for this lesson
        progressRef.whereField("lessonId", isEqualTo: lessonId).getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }

            if let document = snapshot?.documents.first {
                // If progress exists, update it
                document.reference.updateData(["status": status.rawValue]) { error in
                    completion(error)
                }
            } else {
                // If progress does not exist, create a new entry
                let newProgress = LessonProgress(userId: userId, lessonId: lessonId, status: status)
                let newProgressRef = progressRef.document(newProgress.id.uuidString)

                let data: [String: Any] = [
                    "id": newProgress.id.uuidString,
                    "userId": newProgress.userId,
                    "lessonId": newProgress.lessonId,
                    "status": newProgress.status.rawValue
                ]

                newProgressRef.setData(data) { error in
                    completion(error)
                }
            }
        }
    }


    // Fetch all lessons for a user
    func fetchLessonProgress(userId: String, completion: @escaping ([LessonProgress]) -> Void) {
        db.collection("users").document(userId).collection("lessonProgress").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching lesson progress: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            let progressData = documents.compactMap { document -> LessonProgress? in
                let data = document.data()

                guard let idString = data["id"] as? String,
                      let id = UUID(uuidString: idString), // Ensure ID remains a UUID
                      let lessonId = data["lessonId"] as? String,
                      let statusRaw = data["status"] as? String,
                      let status = LessonStatus(rawValue: statusRaw) else { return nil }

                return LessonProgress(userId: userId, lessonId: lessonId, status: status)
            }

            completion(progressData)
        }
    }

    
    // Save Health Data to Firestore
    func saveHealthData(userId: String, heartRateVariability: [String: Double], sleepData: [String: Double]) {
        let userRef = db.collection("users").document(userId)
        
        let data: [String: Any] = [
            "heartRateVariability": heartRateVariability,
            "sleepData": sleepData,
            "timestamp": Timestamp(date: Date())
        ]
        
        userRef.collection("healthData").addDocument(data: data) { error in
            if let error = error {
                print("Error saving health data: \(error.localizedDescription)")
            } else {
                print("Health data successfully saved for user \(userId)")
            }
        }
    }

    func addTestHeartRateData() {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated")
            return
        }
        
        let userID = user.uid
        print("Current authenticated user ID: \(userID)")
        
        let heartRateCollection = db.collection("HRVAverage")   
        let currentTime = Date()
        let calendar = Calendar.current
        
        for i in 0..<7 {
            let timestamp = calendar.date(byAdding: .day, value: -i, to: currentTime)!
            let startOfDay = calendar.startOfDay(for: timestamp)
            let firebaseTimestamp = Timestamp(date: startOfDay) // Convert to Firestore Timestamp
            let heartRate = Int.random(in: 15...100) // Generate random heart rate
            
            let heartRateEntry = HRVAverage (
                name: "Test Heart Rate Data 2",
                value: heartRate,
                date: firebaseTimestamp, // Store date as a timestamp (seconds since 1970)
                user: userID // Change this to the actual user identifier if available
            )
            
            heartRateCollection.addDocument(data: [
                "name": heartRateEntry.name,
                "value": heartRateEntry.value ?? NSNull(),
                "date": Timestamp(date: startOfDay), // Use Firestore Timestamp instead of Double
                "user": heartRateEntry.user ?? NSNull()
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Heart rate data added successfully")
                }
            }
        }
    }

}
