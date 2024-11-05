//
//  MainMenuView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/5/24.
//

import SwiftUI

struct MainMenuView: View {
    // Assuming MainMenuView manages its own state or fetches data internally
    @State private var modules: [Module] = [
        Module(title: "Stress is SO overwhelming!", progress: "15/15", buttonText: "View", isLocked: false),
        Module(title: "Burnout’s a bummer", progress: "9/35", buttonText: "Next", isLocked: false),
        Module(title: "Band-Aid vs. Armor", progress: "9/15", buttonText: "Next", isLocked: false),
        Module(title: "Resilience to the rescue!", progress: "0/95", buttonText: "Start", isLocked: true)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Example Header
                HStack {
                    Text("Module 1")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(modules) { module in
                            ModuleCard(module: module)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                

            }
            .navigationTitle("Main Menu")
            .navigationBarHidden(true)
        }
    }
}

struct ModuleCard: View {
    let module: Module
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(module.title)
                .font(.headline)
            
            Text("Progress: \(module.progress)")
                .font(.subheadline)
                .foregroundColor(module.isLocked ? .gray : .green)
            
            Button(action: {
                // Handle button action
            }) {
                Text(module.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(module.isLocked ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
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
