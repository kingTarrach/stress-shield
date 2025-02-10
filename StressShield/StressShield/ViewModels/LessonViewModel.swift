//
//  LessonViewModel.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/9/25.
//

import SwiftUI

class LessonViewModel: ObservableObject {
    @Published var lessons: [LessonProgress] = []
    private let firestoreService = FirestoreService()
    private let userId = "user123"  // Replace with actual authentication logic

    init() {
        fetchLessonProgress()
    }

    func fetchLessonProgress() {
        firestoreService.fetchLessonProgress(userId: userId) { [weak self] progressData in
            DispatchQueue.main.async {
                self?.lessons = progressData
            }
        }
    }

    func updateProgress(for lessonId: String, status: LessonStatus) {
        firestoreService.updateLessonProgress(userId: userId, lessonId: lessonId, status: status) { error in
            if let error = error {
                print("Error updating progress: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    if let index = self.lessons.firstIndex(where: { $0.lessonId == lessonId }) {
                        self.lessons[index].status = status
                    }
                }
            }
        }
    }
}
