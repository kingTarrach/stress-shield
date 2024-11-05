//
//  ProfileView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 10/5/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewVM()
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: 125, height: 125)
                    
                    // Info
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name: ")
                                .bold()
                            Text(user.name)
                        }
                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(user.email)
                        }
                    }
                    
                    // Log out
                    Button {
                        viewModel.logOut()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.red)
                                .frame(width: 100, height: 40)
                            
                            Text("Log Out")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding(.top, 350)
                } else {
                    Text("Loading Profile...")
                }
            }
            .padding()
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser()
            }
        }
    }
}

#Preview {
    ProfileView()
}
