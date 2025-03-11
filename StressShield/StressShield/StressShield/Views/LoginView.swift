//
//  LogInView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewVM()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Logo
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                    
                    // Error Message
                    if !viewModel.errorMsg.isEmpty {
                        Text(viewModel.errorMsg)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    // Login Form
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("", text: $viewModel.email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        SecureField("", text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 30)
                    
                    // Login Button
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("LOG IN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

                    // Create Account Section
                    HStack {
                        Text("New User?")
                            .foregroundColor(.white)
                        
                        NavigationLink("Create An Account", destination: RegisterView())
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
