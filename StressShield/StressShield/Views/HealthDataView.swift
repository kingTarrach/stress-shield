//
//  HealthDataView.swift
//  StressShield
//
//  Created by Austin Tarrach on 2/14/25.
//

import SwiftUI

struct HealthDataView: View {
    @StateObject var healthDataManager = HealthDataManager() // Use StateObject to manage its lifecycle

    var body: some View {
        Text("Health Data Manager Loaded")
    }
}
