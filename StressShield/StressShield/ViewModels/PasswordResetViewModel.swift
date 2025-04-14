import Foundation
import FirebaseAuth

class PasswordResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func sendPasswordReset() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.successMessage = nil
                } else {
                    self.successMessage = "Password reset email sent! Check your inbox."
                    self.errorMessage = nil
                }
            }
        }
    }
}
