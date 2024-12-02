//
//  Lesson1View.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 11/5/24.
//

import SwiftUI

struct LessonView: View {
    let lessonNumber: Int
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.yellow)
                    .frame(width: 1000, height: 200)
                    .offset(y: -70)
                // Header Section
                VStack(alignment: .leading) {
                    Text("Module 1, Lesson \(lessonNumber)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Understand the overwhelming nature of stress")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .offset(y: -20)
            }
            
            .padding()
            .padding()
            .offset(y: -20)
            
            Spacer().frame(height: 20)
            
            // Lesson Steps Path
            VStack(spacing: 50) {
                // Step 1 - Start (Unlocked and clickable)
                LessonStep(icon: "star.fill", label: "START", isLocked: false, color: .green)
                    .offset(x: -50)
                
                // Step 2 - Locked
                LessonStep(icon: "lock.fill", label: "", isLocked: true, color: .gray)
                    .offset(x: 50)
                
                // Step 3 - Locked Chest
                LessonStep(icon: "archivebox.fill", label: "", isLocked: true, color: .gray)
                    .offset(x: -50)
                
                // Step 4 - Locked Book
                LessonStep(icon: "book.fill", label: "", isLocked: true, color: .gray)
                    .offset(x: 50)
                
                // Step 5 - Locked Trophy
                LessonStep(icon: "trophy.fill", label: "", isLocked: true, color: .gray)
                    .offset(x: -50)
            }
            .offset(y: -100)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

// Subview for each lesson step
struct LessonStep: View {
    let icon: String
    let label: String
    let isLocked: Bool
    let color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .strokeBorder(lineWidth: 3)
                    .foregroundColor(color.opacity(0.5))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            
            if !label.isEmpty {
                Text(label)
                    .font(.caption)
                    .foregroundColor(color)
                    .padding(.top, 5)
            }
        }
    }
}

#Preview {
    LessonView(lessonNumber: 1)
}
