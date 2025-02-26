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
                
                VStack {
                    // Header
    //                ZStack {
    //                    RoundedRectangle(cornerRadius: 0)
    //                        .foregroundColor(.green)
    //                        .offset(y: -50)
    //
    //                    Text("Register")
    //                        .font(.system(size: 50))
    //                        .foregroundColor(Color.white)
    //                        .bold()
    //                        .padding(.top, 20)
    //                }
    //                .frame(width: UIScreen.main.bounds.width * 3, height: 300)
    //                .offset(y: -100)
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                    
                    // Register Form
                    Form {
                        if !viewModel.errorMsg.isEmpty {
                            Text(viewModel.errorMsg)
                                .foregroundColor(.red)
                        }
                        TextField("Full Name", text: $viewModel.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                        
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button {
                            viewModel.register()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                
                                Text("CREATE YOUR ACCOUNT")
                                    .foregroundColor(.white)
                                    .bold()
                                
                            }
                        }
                    }
                    .padding(.bottom, 50)
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    
                    Spacer()
                }
                
            }
            
        }
    }
}

#Preview {
    RegisterView()
}
