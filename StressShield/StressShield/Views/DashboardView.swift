//
//  DashboardView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 3/6/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = ProfileViewVM()
    @AppStorage("hasCheckedInToday") private var hasCheckedInToday: Bool = false // Stores check-in state

    var body: some View {
        Group {
            if let user = viewModel.user {
                let timeOfDay = getTimeOfDay()
                
                NavigationStack {
                    ZStack {
                        Color.black.ignoresSafeArea()
                        
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // Dynamic Greeting Text
                            Text("Good \(timeOfDay), \(user.name)!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            // Check-in Section (Extracted into a separate view)
                            CheckInCardView(hasCheckedInToday: $hasCheckedInToday)

                            // Yesterday's Score Section
                            yesterdayScoreSection

                            // Goals Section
                            goalsSection

                            Spacer()
                        }
                        .padding()
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            resetCheckInIfNewDay()
            viewModel.fetchUser()
        }
    }
    
    func resetCheckInIfNewDay() {
        let lastCheckInDate = UserDefaults.standard.string(forKey: "lastCheckInDate") ?? ""
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)

        if lastCheckInDate != today {
            hasCheckedInToday = false
            UserDefaults.standard.set(today, forKey: "lastCheckInDate")
        }
    }
    
    // Extract Yesterday’s Score Section into a computed property
    private var yesterdayScoreSection: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 100)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("Yesterday’s Score")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("You’re on track! Nice work!")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    Spacer()
                    Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("90")
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                }
                .padding()
            )
    }

    // Extract Goals Section into a computed property
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Goals you achieved yesterday")
                .font(.headline)
                .foregroundColor(.white)
            
            GoalItem(title: "7 hours of sleep", iconName: "zzz")
            GoalItem(title: "Keep stress response within optimal range", iconName: "heart")
            GoalItem(title: "Meditate for 20 minutes", iconName: "heart")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
    }
}
    
    // Determines the time of day
    func getTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "morning"
        case 12..<18:
            return "afternoon"
        default:
            return "evening"
        }
    }

struct CheckInCardView: View {
    @Binding var hasCheckedInToday: Bool
    
    var body: some View {
        if !hasCheckedInToday {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Are you ready to check-in?")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            NavigationLink(destination: CheckInView(hasCheckedInToday: $hasCheckedInToday)) {
                                Text("YES")
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {
                                // Later Action
                            }) {
                                Text("LATER")
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                )
        }
    }
}


// Custom Goal Item View
struct GoalItem: View {
    var title: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.gray.opacity(0.5))
                .clipShape(Circle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
    }
}

#Preview {
    DashboardView()
}
