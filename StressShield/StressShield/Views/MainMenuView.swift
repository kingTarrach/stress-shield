//
//  MainMenuView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/5/24.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Example module cards with lesson numbers
                    ModuleCard(
                        module: Module(title: "Stress is SO overwhelming!", progress: "15/15", buttonText: "View", isLocked: false),
                        lessonNumber: 1
                    )
                    
                    ModuleCard(
                        module: Module(title: "Burnout’s a bummer", progress: "9/35", buttonText: "Next", isLocked: false),
                        lessonNumber: 2
                    )
                    
                    ModuleCard(
                        module: Module(title: "Band-Aid vs. Armor", progress: "9/15", buttonText: "Next", isLocked: false),
                        lessonNumber: 3
                    )
                    
                    ModuleCard(
                        module: Module(title: "Resilience to the rescue!", progress: "0/95", buttonText: "Start", isLocked: true),
                        lessonNumber: 4
                    )
                }
                .padding()
            }
            .navigationTitle("Module 1")
        }
    }
}



struct ModuleCard: View {
    let module: Module
    let lessonNumber: Int // Add lesson number parameter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(module.title)
                .font(.headline)
            
            Text("Progress: \(module.progress)")
                .font(.subheadline)
                .foregroundColor(module.isLocked ? .gray : .green)
            
            NavigationLink(destination: LessonView(lessonNumber: lessonNumber)) {
                Text(module.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(module.isLocked ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .disabled(module.isLocked)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}



struct NavigationButton: View {
    let iconName: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 24, height: 24)
            Text(label)
                .font(.caption)
        }
    }
}

struct Module: Identifiable {
    let id = UUID()
    let title: String
    let progress: String
    let buttonText: String
    let isLocked: Bool
}


#Preview {
    MainMenuView()
}
