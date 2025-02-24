//
//  MainViewVM.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import FirebaseAuth
import Foundation

class MainViewVM: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?

    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
        
        // Request HealthKit authorization after successful login
        HealthDataManager.shared.requestAuthorization { success in
            DispatchQueue.main.async {
                if success {
                    print("HealthKit authorization granted.")
                    HealthDataManager.shared.enableBackgroundDelivery()
                } else {
                    print("HealthKit authorization denied.")
                }
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
