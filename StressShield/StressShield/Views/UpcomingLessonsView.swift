//
//  UpcomingLessonsView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 11/8/24.
//

import SwiftUI

struct UpcomingLessonsView: View {
    let scheduledLessons: [ScheduledLesson]
    
    var body: some View {
        VStack {
            if scheduledLessons.isEmpty {
                Text("No lessons scheduled yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(scheduledLessons) { lesson in
                    HStack {
                        Text(lesson.lessonTitle)
                        Spacer()
                        Text(lesson.date, style: .date)
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Upcoming Lessons")
        .padding()
    }
}

struct UpcomingLessonsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLessonsView(scheduledLessons: [
            ScheduledLesson(date: Date(), lessonTitle: "Lesson 1: Introduction to Stress"),
            ScheduledLesson(date: Date().addingTimeInterval(86400), lessonTitle: "Lesson 2: Coping Mechanisms")
        ])
    }
}

#Preview {
    UpcomingLessonsView(scheduledLessons: [
        ScheduledLesson(date: Date(), lessonTitle: "Lesson 1: Introduction to Stress"),
        ScheduledLesson(date: Date().addingTimeInterval(86400), lessonTitle: "Lesson 2: Coping Mechanisms"),
        ScheduledLesson(date: Date().addingTimeInterval(2 * 86400), lessonTitle: "Lesson 3: Managing Daily Stress")
    ])
}

