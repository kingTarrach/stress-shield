//
//  RegisterView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/4/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewVM()
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

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
                            .padding()
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Registration Form
                    VStack(alignment: .leading, spacing: 15) {
                        Text("First Name")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("", text: $viewModel.firstName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .autocorrectionDisabled()
                        
                        Text("Last Name")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("", text: $viewModel.lastName)
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
                        
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("", text: $viewModel.password)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            } else {
                                SecureField("", text: $viewModel.password)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        ZStack(alignment: .trailing) {
                            if isConfirmPasswordVisible {
                                TextField("", text: $viewModel.confirmPassword)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            } else {
                                SecureField("", text: $viewModel.confirmPassword)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            }

                            Button(action: {
                                isConfirmPasswordVisible.toggle()
                            }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
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
