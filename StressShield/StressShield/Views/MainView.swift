//
//  ContentView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewVM()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                // signed in
                MainMenuView()
                    .tabItem {
                        Label("Home", systemImage: "house")
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
                
                // Calendar Tab
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
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
