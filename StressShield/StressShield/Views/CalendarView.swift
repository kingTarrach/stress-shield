//
//  CalendarView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 11/5/24.
//

import SwiftUI

struct ScheduledLesson: Identifiable {
    let id = UUID()
    let date: Date
    let lessonTitle: String
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var selectedLesson = ""
    @State private var scheduledLessons: [ScheduledLesson] = []
    
    let availableLessons = ["Lesson 1: Introduction to Stress", "Lesson 2: Coping Mechanisms", "Lesson 3: Managing Daily Stress", "Lesson 4: Advanced Techniques"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Schedule a Lesson")
                    .font(.headline)
                
                // Date Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                // Lesson Picker
                Picker("Select Lesson", selection: $selectedLesson) {
                    ForEach(availableLessons, id: \.self) { lesson in
                        Text(lesson)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
                // Add Lesson Button
                Button(action: addScheduledLesson) {
                    Text("Add Lesson to Schedule")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedLesson.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedLesson.isEmpty)
                .padding(.horizontal)
                
                // Navigation Button to Upcoming Lessons
                NavigationLink(destination: UpcomingLessonsView(scheduledLessons: scheduledLessons)) {
                    Text("View Upcoming Lessons")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }
    
    // Function to add a scheduled lesson
    private func addScheduledLesson() {
        let newLesson = ScheduledLesson(date: selectedDate, lessonTitle: selectedLesson)
        scheduledLessons.append(newLesson)
        selectedLesson = "" // Reset the selected lesson
    }
}


#Preview {
    CalendarView()
}
