//
//  ForgotPasswordView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 3/31/25.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordVM()

    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            TextField("Enter your email", text: $viewModel.email)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .foregroundColor(.black)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 30)

            Button(action: {
                viewModel.sendResetLink()
            }) {
                if viewModel.message.isEmpty {
                    Text("SEND RESET LINK")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                } else {
                    Text("SEND RESET LINK AGAIN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal, 30)

            if !viewModel.message.isEmpty {
                if viewModel.message.contains("No account found") || viewModel.message.contains("Please enter a valid email") || viewModel.message.contains("Please enter your email.") {
                    Text(viewModel.message)
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                } else {
                    Text("A reset link has been sent to your email.")
                        .font(.body)
                        .foregroundColor(.green)
                        .padding(.horizontal)
                }
            }

            Spacer()
        }
        .padding(.top, 40)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ForgotPasswordView()
}
