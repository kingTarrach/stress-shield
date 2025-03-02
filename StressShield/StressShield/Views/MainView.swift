//
//  ContentView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewVM()
    
    var firebaseViewModel = FirebaseVM()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                // signed in
                MainMenuView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }.onAppear {
                        firebaseViewModel.addTest()
                    }
                
                // Data Analytics Tab
                DataAnalyticsView()
                    .tabItem {
                        Label("Data Analytics", systemImage: "chart.bar.fill")
                    }
                
                // Learn Tab
                LearnView()
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }
                
                AICoachView(url: URL(string: "https://app.coachvox.ai/avatar/HhVpxzXud6ZD3Yiw9AQf/fullscreen")!)
                    .tabItem {
                        Label("AI Coach", systemImage: "brain.head.profile")
                    }

                ProfileView()
                    .tabItem {
                        Label("My Profile", systemImage: "person.circle")
                    }
            }
        }
        else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
