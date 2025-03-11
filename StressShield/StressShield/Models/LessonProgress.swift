//
//  LessonProgress.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/9/25.
//

import SwiftUI
import AVKit

enum LessonStatus: String, Codable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case completed = "completed"
}

struct LessonProgress: Identifiable, Codable {
    let id = UUID()
    let userId: String  // Unique user identifier
    let lessonId: String  // Unique lesson identifier
    var status: LessonStatus  // Enum tracking progress
}
