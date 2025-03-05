//
//  TutorialView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 2/25/25.
//

import SwiftUI

struct TutorialView: View {
    @Binding var hasSeenTutorial: Bool
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            TutorialPage(
                title: "Welcome to StressShield!",
                subtitle: "Your Stress Resilience Quest Begins",
                description: "Life is full of challenges—work, family, finances... Some days, it feels like you're constantly dodging stress.\n\nBut what if you could stress into your superpower? What if building resilience was fun, easy, and rewarding?\n\nThat's exactly what StressShield is all about.\n\nNo long lectures, no complicated routines. Just fun quests that fit into your already busy life.",
                buttonText: "LET'S GO!",
                onNext: { currentPage += 1 }
            ).tag(0)
            
            TutorialPage(
                title: "",
                subtitle: "The Stress Epidemic Is Real.",
                description: "Stress isn't just in your head–it's everywhere.\n\n🟦77% of people say stress hurts\n     their health\n🟦63% say  stress affects their\n     relationships\n🟦83% feel burned out and \n     unmotivated\n\nBut here's the good news: resilience is a skill-and you can train it.\n\nJust like leveling up in a game, you can retrain your mind and body to handle stress better.",
                buttonText: "I WANT THAT!",
                onNext: { currentPage += 1 }
            ).tag(1)
            
            TutorialPage(
                title: "",
                subtitle: "Stress Happens. Resilience is Trainable.",
                description: "Most people just push through stress-until it catches up with them.\n\n Burnout. Exhaustion. Overwhelm.\n\nNot anymore. With StressShield, you'll take control of stress before it takes control of you:\n\n 🟦Track your stress in real time\n 🟦Train with bite-sized, \n       science-backed challenges\n 🟦Strenghten your stress \n       resilience armor\n\n And the best part? It's fast, fun, and stress-free–so you can thrive, not just survive.",
                buttonText: "I WANT THAT!",
                onNext: { currentPage += 1 }
            ).tag(2)
            
            TutorialPage(
                title: "",
                subtitle: "Try It Free—No Strings Attached",
                description: "StressShield is built on real science, designed to be lighthearted and fun, and field-tested by real people.\n\n 🟦Grounded in neuroscience, \n       physiology, and \n       educational psychology\n 🟦Designed for busy people\n 🟦Focused on building \n       lasting resilience\n\n Users report:\n 🟦30% more energy\n 🟦40% better focus & productivity\n 🟦50% fewer \n       stress-related symptoms\n\nImagine feeling like yourself again–but even better.",
                buttonText: "START MY FREE TRIAL",
                onNext: {
                    UserDefaults.standard.set(true, forKey: "hasSeenPreLoginTutorial") // Persist flag
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        hasSeenTutorial = true
                    }
                }
            ).tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onDisappear {
            UserDefaults.standard.set(true, forKey: "hasSeenPreLoginTutorial")
        }
    }
}

#Preview {
    TutorialView(hasSeenTutorial: .constant(false))
}
