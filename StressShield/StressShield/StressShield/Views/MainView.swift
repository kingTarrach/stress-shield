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
    @State private var showTutorialOverlay = false
    @State private var hasSeenPreLoginTutorial: Bool?
    @State private var hasSeenPostLoginTutorial: Bool?

    var body: some View {
        ZStack {
            if let hasSeenPreLogin = hasSeenPreLoginTutorial,
               let hasSeenPostLogin = hasSeenPostLoginTutorial {
                
                if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                    TabView() {
                        DashboardView()
                            .tabItem {
                                Image(systemName: "house.fill")
                            }
                            .tag(0)

                        LearnView()
                            .tabItem {
                                Image(systemName: "play.rectangle.fill")
                            }
                            .tag(1)

                        AICoachView(url: URL(string: "https://app.coachvox.ai/avatar/HhVpxzXud6ZD3Yiw9AQf/fullscreen")!)
                            .tabItem {
                                Image(systemName: "ellipsis.bubble.fill")
                            }
                            .tag(2)

                        DataAnalyticsView()
                            .tabItem {
                                Image(systemName: "chart.bar.fill")
                            }
                            .tag(3)

                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.fill") 
                            }
                            .tag(4)
                    }
                    .accentColor(.blue) // Makes the icons match the blue color from your image
                    .onAppear {
                        if !hasSeenPostLogin {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showTutorialOverlay = true
                            }
                        }
                    }
                } else if !viewModel.isSignedIn && hasSeenPreLogin {
                    LoginView()
                } else {
                    TutorialView(hasSeenTutorial: Binding(
                        get: { hasSeenPreLoginTutorial ?? false },
                        set: { newValue in
                            hasSeenPreLoginTutorial = newValue
                            UserDefaults.standard.set(newValue, forKey: "hasSeenPreLoginTutorial")
                        }
                    ))
                }

                if showTutorialOverlay {
                    TutorialOverlay(step: $tutorialStep, showTutorial: $showTutorialOverlay)
                        .onDisappear {
                            UserDefaults.standard.set(true, forKey: "hasSeenPostLoginTutorial")
                            showTutorialOverlay = false
                        }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                hasSeenPreLoginTutorial = UserDefaults.standard.bool(forKey: "hasSeenPreLoginTutorial")
                hasSeenPostLoginTutorial = UserDefaults.standard.bool(forKey: "hasSeenPostLoginTutorial")
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
                VStack(spacing: 10) {
                    Text(tutorialTitles[step]) // Title in bold
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()

                    Text(tutorialText[step]) // Description below the title
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.9)) // Dark background for contrast
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: 280)

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

// Tutorial Titles
let tutorialTitles = [
    "Your Resilience Journey Begins Here!",
    "Stay on Track",
    "Learn Stress Resilience",
    "Meet Your Guide, Axia",
    "You'll Need a Compass",
    "Know Where You Are"
]

// Tutorial Messages
let tutorialText = [
    "Every great adventure starts with preparation. Like a knight sharpening their sword, you need the right tools to take on stress and build resilience.\n\nLet's get you set up and ready to go.",
    "It's easy to get distracted by life's side quests–but constistency is key to building resilience.\n\nEach day, you'll get small, actionable steps, real-time nudges, and guided techniques to help you build resilience.\n\nCheck in often to track your progress and keep pushing forward.",
    "Access educational resources for growth.",
    "You won't be on this journey alone.\n\nAxia, your AI-powered resilience mentor, is with you every step of the way. You can chat with Axia any time.\n\nLike a seasoned coach, Axia adapts to your progress, offers real-time advice, and keeps you on track.",
    "Every explorer needs a way to navigate. StressShield uses data from your wearable device to personalize your daily challenges based on your real-time stress levels.\n\nThis info acts like your own compass, helping you track how your body responds to stress so you can adjust and grow stronger.\n\nTo get the most out of your training, sync your device now.",
    "StressShield analyzes your real-time wearable data, check-ins, and completed quests to build your Resilience Profile.\n\nYour Resilience Profile will update based on the progress you make in your journey and improve your stress resilience."
]


// Positions of messages relative to tabs
let tutorialPositions: [CGPoint] = [
    CGPoint(x: 200, y: 400), // Intro
    CGPoint(x: 200, y: 500),  // Home
    CGPoint(x: 200, y: 500), // Data Analytics
    CGPoint(x: 200, y: 500), // Learn
    CGPoint(x: 200, y: 500), // AI Coach
    CGPoint(x: 200, y: 500)  // Profile
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
