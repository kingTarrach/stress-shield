//
//  StressShieldApp.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import FirebaseCore
import SwiftUI

//struct ContentView: View {
//    let lessonPages = [
//        LessonPage(type: .content(.text("Welcome to the lesson!"))),
//        LessonPage(type: .content(.image("exampleImage"))),
//        LessonPage(type: .content(.video("https://www.example.com/video.mp4"))),
//        LessonPage(type: .question(.multipleChoice(question: "What is 2+2?", options: ["3", "4", "5"], correctAnswer: "4")))
//    ]
//    
//    var body: some View {
//        LessonView(pages: lessonPages)
//    }
//}

@main

struct StressShieldApp: App {
    init() {
        FirebaseApp.configure()
        BackgroundTaskManager.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            DataAnalyticsView()
        }
    }
}
