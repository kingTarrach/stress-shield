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
                VStack {
                    // Header
    //                ZStack {
    //                    RoundedRectangle(cornerRadius: 0)
    //                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    //                        .offset(y: -50)
    //
    //                    Text("Stress Shield")
    //                        .font(.system(size: 50))
    //                        .foregroundColor(Color.white)
    //                        .bold()
    //                        .offset(y: -10)
    //
    //
    //                    // Shield Icon
    //                    Image(systemName: "shield")
    //                        .resizable()
    //                        .scaledToFit()
    //                        .frame(width: 60, height: 60)
    //                        .foregroundColor(.white)
    //                        .offset(y: 60)
    //                }
    //                .frame(width: UIScreen.main.bounds.width * 3, height: 300)
    //                .offset(y: -100)
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                    
                    // Login Form
                    Form {
                        if !viewModel.errorMsg.isEmpty {
                            Text(viewModel.errorMsg)
                                .foregroundColor(.red)
                        }
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button {
                            viewModel.login()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                
                                Text("LOG IN")
                                    .foregroundColor(.white)
                                    .bold()
                                
                            }
                        }
                    }
                    .padding(.top, 100)
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    
                    // Create Account
                    VStack {
                        Text("New User?")
                        
                        NavigationLink("Create An Account", destination: RegisterView())

                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                }
            }
            
        }
        
    }
}

#Preview {
    LoginView()
}
