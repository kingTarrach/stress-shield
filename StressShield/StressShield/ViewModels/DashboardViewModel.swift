import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class DashboardViewModel: ObservableObject {
    @Published var todayGoals: [Goal] = []
    @Published var yesterdayGoals: [Goal] = []
    @Published var stress: Int = -1
    
    private let model = FirebaseTools()
    
    private func fetchYesterdayandTodayGoals() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let goals = await model.getCollectionFromFirestore(collection: "Goal", as: Goal.self, userID: userID)
        guard let goals else {
            return
        }
        
        // Get yesterdays goals and todays goals
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOfToday = calendar.startOfDay(for: now) as Date?,
              let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday),
              let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday),
              let endOfYesterday = calendar.date(byAdding: .second, value: -1, to: startOfToday) else {
                return
        }
        
        var yesterdayGoals: [Goal] = []
        var todayGoals: [Goal] = []
        
        for goal in goals {
            if let timestamp = goal.goalDate {
                let date = Date(timeIntervalSince1970: timestamp)
                print(date)
                if date >= startOfYesterday && date <= endOfYesterday {
                    print("Found a goal")
                    yesterdayGoals.append(goal)
                }
                if date >= startOfToday && date <= endOfToday {
                    print("Found a goal")
                    todayGoals.append(goal)
                }
            }
        }
        
        let yesterdayGoalsLet = yesterdayGoals
        let todayGoalsLet = todayGoals
        dump(yesterdayGoals)
        dump(todayGoals)
        
        DispatchQueue.main.async {
            self.yesterdayGoals = yesterdayGoalsLet
            self.todayGoals = todayGoalsLet
        }
    }
    
    private func fetchStress() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let stressScores = await model.getCollectionFromFirestore(collection: "Stress", as: Stress.self, userID: userID)
        guard let stressScores else {
            return
        }
        
        // Get today's stress score
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOfToday = calendar.startOfDay(for: now) as Date?,
              let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
                return
        }
        
        for (index, score) in stressScores.enumerated() {
            if let timestamp = score.date {
                if timestamp.dateValue() >= startOfToday && timestamp.dateValue() <= endOfToday {
                    print("Found a stress score")
                    let stressScore = score.value!
                    DispatchQueue.main.async {
                        self.stress = Int(stressScore)
                    }
                }
            }
        }
    }
    
    func fetchAll() async {
        await fetchYesterdayandTodayGoals()
        await fetchStress()
    }
}
