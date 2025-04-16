import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class CheckInViewModel: ObservableObject {
    @Published var userGoalQuestions: [(question: String, options: [String])] = []
    @Published var userGoals: [Goal] = []
    @Published var userGoalIDs: [String] = []
    
    private let model = FirebaseTools()
    
    private func fetchUserGoals(
        userID: String
    ) async -> [Goal]? {
        return await model.getCollectionFromFirestore(collection: "Goal", as: Goal.self, userID: userID)
    }
    
    private func createUserGoals(
        goal : Goal
    ) async {
        return await model.addDocumentToFirestore(collection: "Goal", document: goal)
    }
    
    private func updateUserGoal(
        goalID : String,
        goal : Goal
    ) async {
        return await model.updateFullDocumentInFirestore(collection: "Goal", documentID: goalID, document: goal)
    }
    
    private func fetchUserGoalIDs(
        userID : String
    ) async -> [String] {
        return await model.getCollectionIDs(collection: "Goal", userID: userID)
    }
    
    private func createStressData(
        stress : Stress
    ) async {
        return await model.addDocumentToFirestore(collection: "Stress", document: stress)
    }
    
    func getGoalQuestions() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        // Fetch the questions and id's
        var goals: [Goal] = []
        var ids: [String] = []
        DispatchQueue.main.async {
            self.userGoals = []
            self.userGoalIDs = []
            self.userGoalQuestions = []
        }
        
        let goalResult = await fetchUserGoals(userID: userID)
        let goalIDResult = await fetchUserGoalIDs(userID: userID)
        guard let goalResult else {
            return
        }
        goals = goalResult
        ids = goalIDResult
        
        print(goals)
        
        // Get yesterdays goals and corresponding ids
        let calendar = Calendar.current
        let now = Date()
        
        guard let startOfToday = calendar.startOfDay(for: now) as Date?,
              let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday),
              let endOfYesterday = calendar.date(byAdding: .second, value: -1, to: startOfToday) else {
                return
        }
        
        print(startOfYesterday)
        print(endOfYesterday)
        
        // Get yesterday
        var yesterdayGoals: [Goal] = []
        var yesterdayIDs: [String] = []
        
        for (index, goal) in goals.enumerated() {
            if let timestamp = goal.goalDate {
                let date = Date(timeIntervalSince1970: timestamp)
                print(date)
                if date >= startOfYesterday && date <= endOfYesterday {
                    print("Found a goal")
                    yesterdayIDs.append(ids[index])
                    yesterdayGoals.append(goal)
                }
            }
        }
        
        // Now that we have the current goals and their ids we can put them in question format.
        var tempQuestions: [(question: String, options: [String])] = []
        
        for userGoal in yesterdayGoals {
            let userGoalQuestion = ("Did you \((userGoal.criteria!).lowercased())?", ["Yes", "No"])
            tempQuestions.append(userGoalQuestion)
        }
        
        let var1 = yesterdayGoals
        let var2 = yesterdayIDs
        let var3 = tempQuestions
        
        DispatchQueue.main.async {
            self.userGoals = var1
            self.userGoalIDs = var2
            self.userGoalQuestions = var3
        }
    }
    
    private func createNewGoal(
        input: Int,
        userID: String
    ) async {
        var goalString = GoalTypes.shared.getRandom(type: input)
        let newGoal = Goal(name: "Goal for \(Date()) \(input)", criteria: goalString, goalDate: Date().timeIntervalSince1970, goalComplete: false, user: userID)
        await createUserGoals(goal: newGoal)
    }
    
    private func generateSleepScore(
        input: Double
    ) -> Double {
        // More than 9 hours of sleep
        if input > 9 {
            // This function steeply drops off from 1 at 9 hours before gradually getting to 0 at 24 hours
            return 1 - (sqrt(input - 9)/sqrt(15))
        }
        // Good sleep
        else if input >= 7 {
            return 1
        }
        // Bad or no sleep
        else {
            // This function steeply drops off from 1 at 7 hours before gradually getting to 0 at 0 hours
            return 1 - (sqrt(0 - input - 7)/sqrt(7))
        }
    }
    
    private func generateHRVScore(
        input: Double
    ) -> Double {
        // Potentially factor in age later if recorded
        
        // Super healthy hrv
        if input > 75 {
            return 1
        }
        // Healthy to slowly healthy
        else if input > 30.4 {
            return (1 - ((pow((input - 75), 2))/2000))
        }
        // Bad bad bad
        else {
            return 0
        }
    }
    
    func processCheckIn(
        responses: [String: String],
        HRV: Double,
        Sleep: Double
    ) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        // Don't know how Austin is handling recording passing to server stuff so it may not be needed.
        // If it is, it should go here.
        
        // Check the results of responses.
        //      This involves generating a partial stress score from the question answers
        //          Just rate things on a scale and add together.
        //      This also involves checking to see how the responses were answered to see what new goals should be made for the day.
        //          If xyz is abc then create that goal.
        //      This also involves checking how the day before's goals were if available
        //          Should also contribute to score.
        //          If they were complete, update the goal
        // Create the stress score
        //      Sleep is 1/4: Between 7-9 hours is full, slowly tapering off but drastically getting worse as getting to extremes of 0 and 24
        //      HRV is 1/4: We don't have age atm, so just assume average user is 25-50. Make 50-70 full, outside falling off
        //      Goals is 1/4: Each question is worth 1/(num goals) of full. No is 0 yes is 1. If no data assume 0.5
        //      Quiz is 1/4: Each question is worth 1/(num questions) of full. No is 0, yes is 1, use 0, 0.33, 0.66, 1 for the multichoice
        
        // Start by getting goal score and updating goals along the way
        var responsesCount = responses.count
        var goalRatings: [Double] = []
        var goalScore: Double = 0
        // If over 8 responses, we know that there were goals for the day before
        if(responsesCount > 8) {
            // Start on the ninth entry, continue until end
            var index = 8
            // While not end of responses
            while(index < responses.count) {
                if responses[String(index)] == "No" {
                    goalRatings.append(0)
                }
                else {
                    // Goal was completed. Need to update server.
                    // Get old goal and update
                    let updatedGoal = Goal(name: self.userGoals[index - 8].name, criteria: self.userGoals[index - 8].criteria, goalDate: self.userGoals[index - 8].goalDate, goalComplete: true, user: self.userGoals[index - 8].user)
                    let GoalID = self.userGoalIDs[index - 8]
                    await updateUserGoal(goalID: GoalID, goal: updatedGoal)
                    goalRatings.append(1)
                }
                // Increment
                index += 1
            }
            // Get total
            let goalsCount = goalRatings.count
            // Get total score
            let totalGoalScore = goalRatings.reduce(0, {x, y in x + y})
            // Divide total score by total to get score
            goalScore = totalGoalScore / Double(goalsCount)
        }
        else {
            // Give moderate benefit if no goals from day before
            goalScore = 0.7
        }
        print(goalScore)
        
        // Continue by getting response scores and creating new goals along the way
        var responseRatings: [Double] = []
        
        for i in 0..<8 {
            var questionResponse = responses[String(i)]
            // Get score
            // This is so hacky because questions placed in view. Wish it was easier but it'd require refactor of another's code
            switch i {
            case 0, 2, 3, 4:
                // Four choice questions
                switch questionResponse {
                    case "Poor", "Stressed", "High", "Foggy":
                        // Add goal
                        await createNewGoal(input: i, userID: userID)
                        responseRatings.append(0)
                        break
                    case "Fair", "Neutral", "Moderate", "Distracted":
                        // Add goal
                        await createNewGoal(input: i, userID: userID)
                        responseRatings.append(0.5)
                        break
                    case "Good", "Calm", "Low", "Clear":
                        responseRatings.append(0.75)
                        break
                    case "Excellent", "Excited", "None", "Sharp":
                        responseRatings.append(1)
                        break
                    default:
                    responseRatings.append(0)
                }
                break
            case 1, 5:
                // Three choice questions
                switch questionResponse {
                case "Low", "Shallow":
                    // Add goal
                    await createNewGoal(input: i, userID: userID)
                    responseRatings.append(0)
                    break
                case "Moderate", "Normal":
                    responseRatings.append(0.5)
                    break
                case "High", "Deep and steady":
                    responseRatings.append(1)
                    break
                default:
                    responseRatings.append(0)
                }
                break
            case 6, 7:
                // Two choice questions
                if questionResponse == "Yes" {
                    responseRatings.append(1)
                }
                else
                {
                    //Create goal
                    await createNewGoal(input: i, userID: userID)
                    responseRatings.append(0)
                }
            default:
                responseRatings.append(0)
                break
            }
            print(responseRatings)
        }
        
        // Get response score
        let responseTotalScore = responseRatings.reduce(0, {x, y in x + y})
        print(responseTotalScore)
        let responseScore = responseTotalScore / 8
        print(responseScore)
        
        // Calculate score from sleep
        // replace input with whatever sleep is
        let sleepScore = generateSleepScore(input: Double.random(in:6.0 ..< 12.0))
        print(sleepScore)
        // Calculate score from HRV
        // replace input with whatever HRV is
        let hrvScore = generateHRVScore(input: Double.random(in:40.0 ..< 80.0))
        print(hrvScore)
        
        // Generate total stress score
        let totalStressScore = responseScore + goalScore + sleepScore + hrvScore
        let stressScore = 100 * (totalStressScore / 4)
        print(stressScore)
        
        let newStress = Stress(name: "Stress", value: stressScore, date: Timestamp(date: Date()), user: userID)
        await createStressData(stress: newStress)
    }
}
