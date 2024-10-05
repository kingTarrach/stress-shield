//
//  StressShieldApp.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import FirebaseCore
import SwiftUI

@main
struct StressShieldApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
