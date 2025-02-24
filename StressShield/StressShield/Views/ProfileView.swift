//
//  ProfileView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/5/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewVM()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.user {
                        HStack {
                            Spacer()
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.brown)
                            Image(systemName: "gearshape")
                                .font(.title2)
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal)
                        
                        // Avatar and Account Information
                        VStack(spacing: 8) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                            
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.brown)
                            
                            Text("Joined since 2/6/24")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 10)
                        
                        // Follower, Following, Words Stats
                        HStack(spacing: 40) {
                            ProfileStat(number: "1,092", label: "Followers")
                            ProfileStat(number: "392", label: "Following")
                            ProfileStat(number: "292", label: "Words")
                        }
                        
                        // Action Buttons
                        HStack(spacing: 20) {
                            Button(action: {
                                // Edit profile action
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // Message action
                            }) {
                                HStack {
                                    Image(systemName: "message")
                                    Text("Message")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .foregroundColor(Color.green)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Statistics Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("📊 Statistics")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.brown)
                            
                            Grid {
                                GridRow {
                                    StatCard(icon: "diamond.fill", color: .blue, number: "176", label: "Total Diamonds")
                                    StatCard(icon: "target", color: .red, number: "11", label: "Total Challenges")
                                }
                                
                                GridRow {
                                    StatCard(icon: "graduationcap.fill", color: .green, number: "576", label: "Lessons Passed")
                                    StatCard(icon: "bolt.fill", color: .yellow, number: "1879", label: "Total Lifetime XP")
                                }
                                
                                GridRow {
                                    StatCard(icon: "brain.head.profile", color: .pink, number: "+5", label: "Stress Score")
                                    StatCard(icon: "star.fill", color: .yellow, number: "55", label: "Top 3 Position")
                                }
                            }
                            Spacer() // Pushes content to the top, making space for the logout button
                                                
                            
                            .padding(.horizontal)
                        }
                    } else {
                        // Log Out Button at the Bottom
                        Button(action: {
                            viewModel.logOut()
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser()
            }
        }
    }
}

// Subview for profile statistics (Followers, Following, Words)
struct ProfileStat: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack {
            Text(number)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brown)
            Text(label)
                .font(.caption)
                .foregroundColor(.brown)
        }
    }
}

// Subview for statistics cards in the grid layout
struct StatCard: View {
    let icon: String
    let color: Color
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            Text(number)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.brown)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    ProfileView()
}
