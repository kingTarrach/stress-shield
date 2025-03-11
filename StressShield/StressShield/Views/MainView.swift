//
//  ContentView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI
import AVKit

struct MainView: View {
    @StateObject var viewModel = MainViewVM()
    @State private var tutorialStep = 0
    @State private var showTutorialOverlay = false
    @State private var hasSeenPreLoginTutorial: Bool?
    @State private var hasSeenPostLoginTutorial: Bool?
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // Set tab bar background color

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    //var moduleViewModel = ModuleViewModel()
    
    var body: some View {
        ZStack {
            if let hasSeenPreLogin = hasSeenPreLoginTutorial,
               let hasSeenPostLogin = hasSeenPostLoginTutorial {
                
                if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                    TabView {
                        DashboardView()
                            .tabItem {
                                customTabItem(imageName: "dashboard")
                            }
                            .tag(0)

                        ModulesView()
                            .tabItem {
                                customTabItem(imageName: "lessons")
                            }
                            .tag(1)

                        AICoachView(url: URL(string: "https://app.coachvox.ai/avatar/HhVpxzXud6ZD3Yiw9AQf/fullscreen")!)
                            .tabItem {
                                customTabItem(imageName: "AICoach")
                            }
                            .tag(2)

                        DataAnalyticsView()
                            .tabItem {
                                customTabItem(imageName: "dataAnalytics")
                            }
                            .tag(3)

                        ProfileView()
                            .tabItem {
                                customTabItem(imageName: "profile")
                            }
                            .tag(4)
                    }
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
    
    func customTabItem(imageName: String) -> some View {
        Label {
            Text("") // Keep the text empty
        } icon: {
            Image(imageName)
                .renderingMode(.template) // Enables color tinting
        }
    }

}

struct TutorialOverlay: View {
    @Binding var step: Int
    @Binding var showTutorial: Bool  // Controls when to hide the tutorial
    let videoURL: URL? = Bundle.main.url(forResource: "sampleVid", withExtension: "mp4")

    var body: some View {
        ZStack {
            // Full-screen dark overlay
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Rectangle()
                        .frame(width: 80, height: 50)
                        .position(tabHighlightPositions[min(step, tabHighlightPositions.count - 1)])
                        .blendMode(.destinationOut)
                )
                .compositingGroup()

            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text(tutorialTitles[step])
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(tutorialText[step])
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    // Show Video Player for last step
                    if step == tutorialTitles.count - 1, let videoURL = videoURL {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .frame(width: 320, height: 180)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: 280)

                Button(action: {
                    if step < tutorialText.count - 1 {
                        step += 1
                    } else {
                        showTutorial = false
                        step = 0
                    }
                }) {
                    Text(step < tutorialText.count - 1 ? "Next" : "Got it!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .position(tutorialPositions[step])
        }
    }
}

// Updated Tutorial Data
let tutorialTitles = [
    "Your Resilience Journey Begins Here!",
    "Stay on Track",
    "Learn Stress Resilience",
    "Meet Your Guide, Axia",
    "You'll Need a Compass",
    "Know Where You Are",
    "The Backstory"
]

let tutorialText = [
    "Every great adventure starts with preparation. Like a knight sharpening their sword, you need the right tools to take on stress and build resilience.\n\nLet's get you set up and ready to go.",
    "It's easy to get distracted by life's side quests–but constistency is key to building resilience.\n\nEach day, you'll get small, actionable steps, real-time nudges, and guided techniques to help you build resilience.\n\nCheck in often to track your progress and keep pushing forward.",
    "Your training ground for resilience starts here.\n\nEach mission is a guided lesson designed to help you build mental strength, manage stress, and grow stronger over time. \n\nComplete missions at your own pace and track your progress as you level up on your journey.",
    "You won't be on this journey alone.\n\nAxia, your AI-powered resilience mentor, is with you every step of the way. You can chat with Axia any time.\n\nLike a seasoned coach, Axia adapts to your progress, offers real-time advice, and keeps you on track.",
    "Every explorer needs a way to navigate. StressShield uses data from your wearable device to personalize your daily challenges based on your real-time stress levels.\n\nThis info acts like your own compass, helping you track how your body responds to stress so you can adjust and grow stronger.\n\nTo get the most out of your training, sync your device now.",
    "StressShield analyzes your real-time wearable data, check-ins, and completed quests to build your Resilience Profile.\n\nYour Resilience Profile will update based on the progress you make in your journey and improve your stress resilience.",
    "Last but not least, you need the quest backstory! (StressShield is designed to be fun, remember!?)\n\nLet's set the stage..."
]


// Positions of messages relative to tabs
let tutorialPositions: [CGPoint] = [
    CGPoint(x: 200, y: 400),
    CGPoint(x: 200, y: 500),
    CGPoint(x: 200, y: 500),
    CGPoint(x: 200, y: 500),
    CGPoint(x: 200, y: 500),
    CGPoint(x: 200, y: 500),
    CGPoint(x: 200, y: 400)
]

// Tab Bar spotlight positions
let tabHighlightPositions: [CGPoint] = [
    CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height),
    CGPoint(x: 40, y: UIScreen.main.bounds.height - 120),
    CGPoint(x: 120, y: UIScreen.main.bounds.height - 120),
    CGPoint(x: 200, y: UIScreen.main.bounds.height - 120),
    CGPoint(x: 280, y: UIScreen.main.bounds.height - 120),
    CGPoint(x: 360, y: UIScreen.main.bounds.height - 120),
    CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
]

#Preview {
//    MainView()
    TutorialOverlay(step: .constant(6), showTutorial: .constant(false))
}
