//
//  RegisterView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewVM()

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
                    
                    // Registration Form
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Full Name")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("", text: $viewModel.name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .autocorrectionDisabled()

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
                        
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        SecureField("", text: $viewModel.confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 30)
                    
                    // Register Button
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("CREATE YOUR ACCOUNT")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
