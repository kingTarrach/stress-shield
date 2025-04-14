import SwiftUI

struct PasswordResetView: View {
    @StateObject private var viewModel = PasswordResetViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.largeTitle)
                .bold()
            
            TextField("Enter your email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
            
            Button(action: {
                viewModel.sendPasswordReset()
            }) {
                Text("Send Reset Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}


