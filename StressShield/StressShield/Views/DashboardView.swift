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
    @StateObject var dashboardVM = DashboardViewModel()
    @State var isLoaded: Bool = false

    var body: some View {
        Group {
            if !isLoaded {
                ProgressView("Loading Dashboard...")
                    .onAppear {
                        Task {
                            await dashboardVM.fetchAll()
                            isLoaded = true
                            print(dashboardVM.todayGoals.count)
                            print(dashboardVM.yesterdayGoals.count)
                        }
                    }
            }
            else {
                Group {
                    if let user = viewModel.user   {
                        let timeOfDay = getTimeOfDay()
                        
                        NavigationStack {
                            ZStack {
                                Color.black.ignoresSafeArea()
                                ScrollView(.vertical) {
                                    VStack(alignment: .leading, spacing: 30) {
                                        
                                        // Dynamic Greeting Text
                                        Text("Good \(timeOfDay), \(user.firstName)!")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 20)
                                        
                                        // Check-in Section (Extracted into a separate view)
                                        CheckInCardView(hasCheckedInToday: $hasCheckedInToday, dashboardVM: dashboardVM)
                                        
                                        // Yesterday's Score Section
                                        yesterdayScoreSection
                                        
                                        // Goals Section
                                        todayGoalsSection
                                        yesterdayGoalsSection
                                    }
                                    .padding()
                                }
                            }
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                }
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
                        if(dashboardVM.stress == -1) {
                            Text("No Record. Why not check in?")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        else if(dashboardVM.stress < 50 ) {
                            Text("You’re super stressed! Take some time for you!")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        else if(dashboardVM.stress < 60 ) {
                            Text("You’re pretty stressed. Breathe. You got this!")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        else if(dashboardVM.stress < 80 ) {
                            Text("You’re Doing It! Keep pushing!")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        else if(dashboardVM.stress < 90 ) {
                            Text("You’re stress resilient! Awesome job!")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        else {
                            Text("You’re a knight of the shield!")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(dashboardVM.stress == -1 ? "?" : "\(dashboardVM.stress)")
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                }
                .padding()
            )
    }

    // Extract Goals Section into a computed property
    private var todayGoalsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's goals")
                .font(.headline)
                .foregroundColor(.white)
            
            if dashboardVM.todayGoals.isEmpty {
                HStack {
                    Spacer()
                    Text("No goals today")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            }
            else {
                ForEach(dashboardVM.todayGoals, id: \.name) { goal in
                    GoalItem(title: goal.criteria!, iconName: "chevron.down.circle", completed: false)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
    }
    
    private var yesterdayGoalsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Yesterday's goals")
                .font(.headline)
                .foregroundColor(.white)
            
            if dashboardVM.yesterdayGoals.isEmpty {
                HStack {
                    Spacer()
                    Text("No goals yesterday")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            }
            else {
                ForEach(dashboardVM.yesterdayGoals, id: \.name) { goal in
                    GoalItem(title: goal.criteria!, iconName: "chevron.left.circle", completed: goal.goalComplete!)
                }
            }
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
    @ObservedObject var dashboardVM: DashboardViewModel
    
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
                            NavigationLink(destination: CheckInView(hasCheckedInToday: $hasCheckedInToday).onDisappear() { Task { await dashboardVM.fetchAll()} }) {
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
    var completed: Bool
    
    var body: some View {
        HStack {
            Image(systemName: completed ? "checkmark.circle.fill" : "ellipsis.circle.fill")
                .foregroundColor(completed ? .blue : .gray)
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
