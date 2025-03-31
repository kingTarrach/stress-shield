//
//  ForgotPasswordVM.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 3/31/25.
//

import FirebaseAuth
import Foundation

class ForgotPasswordVM: ObservableObject {
    @Published var email = ""
    @Published var message = ""
    
    func sendResetLink() {
        // Ensure the email is not empty
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Please enter your email."
            return
        }
        
        // Ensure email format is valid
        guard email.contains("@") && email.contains(".") else {
            message = "Please enter a valid email address."
            return
        }
        
        // Send password reset request to Firebase
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "Error: \(error.localizedDescription)"
                } else {
                    self.message = "A password reset link has been sent to \(self.email)."
                }
            }
        }
    }
}

