//
//  ContentView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewVM()
    @State private var tutorialStep = 0
    @State private var showTutorial = true

    var body: some View {
        ZStack {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                TabView {
                    MainMenuView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                    
                    DataAnalyticsView()
                        .tabItem {
                            Label("Data Analytics", systemImage: "chart.bar.fill")
                        }
                        .tag(1)
                    
                    LearnView()
                        .tabItem {
                            Label("Learn", systemImage: "book.fill")
                        }
                        .tag(2)
                    
                    AICoachView(url: URL(string: "https://app.coachvox.ai/avatar/HhVpxzXud6ZD3Yiw9AQf/fullscreen")!)
                        .tabItem {
                            Label("AI Coach", systemImage: "brain.head.profile")
                        }
                        .tag(3)

                    ProfileView()
                        .tabItem {
                            Label("My Profile", systemImage: "person.circle")
                        }
                        .tag(4)
                }
            } else {
                LoginView()
            }
            
            // Always Show Tutorial on App Launch
            if showTutorial, viewModel.isSignedIn {
                TutorialOverlay(step: $tutorialStep, showTutorial: $showTutorial)
            }
        }
    }
}

struct TutorialOverlay: View {
    @Binding var step: Int
    @Binding var showTutorial: Bool  // Controls when to hide the tutorial

    var body: some View {
        ZStack {
            // Full-screen dark overlay
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    // Transparent cutout effect
                    Rectangle()
                        .frame(width: 80, height: 50)
                        .position(tabHighlightPositions[min(step, tabHighlightPositions.count - 1)]) // Moves cutout per step
                        .blendMode(.destinationOut)
                )
                .compositingGroup()

            VStack(spacing: 20) {
                Text(tutorialText[step])
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(width: 250)

                Button(action: {
                    if step < tutorialText.count - 1 {
                        step += 1
                    } else {
                        showTutorial = false  // Hide tutorial when done
                        step = 0
                    }
                }) {
                    Text(step < tutorialText.count - 1 ? "Next" : "Got it!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 100)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
            }
            .position(tutorialPositions[step]) // Moves text above each tab
        }
        .animation(.easeInOut(duration: 0.5), value: step) // Smooth transition
    }
}


// Tutorial Messages
let tutorialText = [
    "Welcome! Let's explore the app.",
    "This is the Home tab. Find your main dashboard with lessons here.",
    "The Data Analytics tab helps track your progress.",
    "The Learn tab provides educational resources.",
    "Meet your AI Coach! Get personalized guidance.",
    "Manage your profile and settings here."
]

// Positions of messages relative to tabs
let tutorialPositions: [CGPoint] = [
    CGPoint(x: 200, y: 400), // Intro
    CGPoint(x: 125, y: 600),  // Home
    CGPoint(x: 163.75 , y: 600), // Data Analytics
    CGPoint(x: 202.5, y: 600), // Learn
    CGPoint(x: 241.25, y: 600), // AI Coach
    CGPoint(x: 280, y: 600)  // Profile
]

// Tab Bar spotlight positions
let tabHighlightPositions: [CGPoint] = [
    CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height),  // Intro
    CGPoint(x: 40, y: UIScreen.main.bounds.height - 120),  // Home
    CGPoint(x: 120, y: UIScreen.main.bounds.height - 120), // Data Analytics
    CGPoint(x: 200, y: UIScreen.main.bounds.height - 120), // Learn
    CGPoint(x: 280, y: UIScreen.main.bounds.height - 120), // AI Coach
    CGPoint(x: 360, y: UIScreen.main.bounds.height - 120)  // Profile
]

#Preview {
    MainView()
}
