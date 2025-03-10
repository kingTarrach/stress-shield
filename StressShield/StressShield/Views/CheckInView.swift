//
//  CheckInView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 3/6/25.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct CheckInView: View {
    @State private var stepIndex = 0 // Tracks the current step
    @State private var responses: [String: String] = [:] // Stores user responses
    @Environment(\.dismiss) var dismiss // For navigating back
    @Binding var hasCheckedInToday: Bool
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    let questions: [(question: String, options: [String])] = [
        ("How did you sleep last night?", ["Poor", "Fair", "Good", "Excellent"]),
        ("What’s your energy level right now?", ["Low", "Moderate", "High"]),
        ("How are you feeling emotionally?", ["Stressed", "Neutral", "Calm", "Excited"]),
        ("How is your physical tension or discomfort?", ["High", "Moderate", "Low", "None"]),
        ("How would you rate your focus and mental clarity?", ["Foggy", "Distracted", "Clear", "Sharp"]),
        ("How is your breathing right now?", ["Shallow", "Normal", "Deep and steady"]),
        ("Have you connected with anyone socially today?", ["Yes", "No"]),
        ("Have you taken a mindful pause or break today?", ["Yes", "No"])
    ]
    
    var body: some View {
        VStack {
            // Top Header Section
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentDate)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("check-in")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color(.darkGray))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Progress Indicator
            HStack {
                ForEach(0..<questions.count, id: \.self) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(index <= stepIndex ? .blue : .gray)
                    
                    if index < questions.count - 1 {
                        Rectangle()
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(index < stepIndex ? .blue : .gray)
                            .padding(.leading, -7)
                            .padding(.trailing, -7)
                    }
                }
            }
            .padding(.top, 5)
            .padding(20)
            
            // Dynamic Question View
            QuestionView(
                question: questions[stepIndex].question,
                options: questions[stepIndex].options,
                selectedOption: Binding(
                    get: { responses["\(stepIndex)"] ?? "" },
                    set: { responses["\(stepIndex)"] = $0 }
                )
            )
            
            Spacer()
            
            // Navigation Buttons
            HStack {
                if stepIndex > 0 {
                    Button(action: {
                        stepIndex -= 1
                    }) {
                        Text("BACK")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    if stepIndex < questions.count - 1 {
                        stepIndex += 1
                    } else {
                        saveCheckInData()
                    }
                }) {
                    Text(stepIndex < questions.count - 1 ? "CONTINUE" : "FINISH")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    // Function to Save Data to Firestore
    private func saveCheckInData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let checkInData: [String: Any] = [
            "userId": userId,
            "date": currentDate,
            "responses": responses
        ]
        
        db.collection("checkIns").addDocument(data: checkInData) { error in
            if let error = error {
                print("Error saving check-in: \(error.localizedDescription)")
            } else {
                print("Check-in saved successfully!")
                hasCheckedInToday = true // Hide check-in card on Dashboard
                dismiss() // Dismiss view
            }
        }
    }
}

// QuestionView Component
struct QuestionView: View {
    var question: String
    var options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .foregroundColor(.white)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedOption == option ? .blue : .gray)
                            .font(.title2)
                        
                        Text(option)
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    CheckInView(hasCheckedInToday: .constant(false))
}
