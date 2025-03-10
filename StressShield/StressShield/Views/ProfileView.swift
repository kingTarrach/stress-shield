//
//  ProfileView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/5/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewVM() // ViewModel for user data

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Background color
            
            if let user = viewModel.user {
                ScrollView {
                    VStack(spacing: 20) {
                        // Level and progress
                        HStack {
                            Text("Lvl 1")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            ProgressView(value: 0.2)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(width: 200)
                            Spacer()
                            Image(systemName: "shield.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        // Profile Image and Name
                        VStack {
                            // Dynamic User Name
                            Text(user.name)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                // Edit action
                            }) {
                                Text("EDIT")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 75, height: 37.5)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .font(.system(size: 12))
                                    
                            }
                        }
                        
                        // Goals Section
                        VStack(alignment: .leading) {
                            Text("Goals")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                StatCard(icon: "target", value: "5", label: "Completed Goals")
                                StatCard(icon: "bolt.fill", value: "1879", label: "Total Lifetime XP")
                            }
                        }
                        
                        // Learning Section
                        VStack(alignment: .leading) {
                            Text("Learning")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                StatCard(icon: "square.stack.3d.up.fill", value: "2", label: "Completed Sections")
                                StatCard(icon: "text.alignleft", value: "0", label: "Completed Lessons")
                            }
                            HStack {
                                StatCard(icon: "square.grid.2x2.fill", value: "0", label: "Completed Modules")
                            }
                        }
                        
                        // Log Out Button
                        Button(action: {
                            viewModel.logOut()
                        }) {
                            Text("LOG OUT")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                }

            } else {
                // Loading Screen
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.largeTitle)
            
            Text(value)
                .font(.title)
                .foregroundColor(.white)
            
            Text(label)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(width: 150, height: 100)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
}
