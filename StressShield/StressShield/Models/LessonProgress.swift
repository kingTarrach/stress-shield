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
    var id = UUID()
    let userId: String  // Unique user identifier
    let lessonId: String  // Unique lesson identifier
    var status: LessonStatus  // Enum tracking progress
    
    init(id: UUID? = nil, userId: String, lessonId: String, status: LessonStatus) {
        
        if let providedId = id {
            self.id = providedId
        } else {
            self.id = UUID()  // Generate a new UUID only when creating a new lesson progress
        }
        
        self.userId = userId
        self.lessonId = lessonId
        self.status = status
    }
}
