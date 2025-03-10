//
//  DashboardView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 3/6/25.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Greeting Text
                    Text("Good morning, John Doe!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Check-in Section
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 100)
                        .overlay(
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Are you ready to check-in?")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    NavigationLink(destination: CheckInView()) {
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
                    
                    // Yesterday's Score Section
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
                    
                    // Goals Section
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
                    
                    Spacer()
                }
                .padding()
            }
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
