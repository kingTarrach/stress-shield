//
//  TutorialPage.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 2/25/25.
//

import SwiftUI

struct TutorialPage: View {
    var title: String
    var subtitle: String
    var description: String
    var buttonText: String
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(width: 400, height: 100)
                if !title.isEmpty {
                    Text(title)
                        .font(.largeTitle).bold()
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                
            }
            
            Text(subtitle)
                .font(.title3).bold()
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .frame(maxWidth: 300)
      
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
                .frame(maxWidth: 350)
                .lineSpacing(4)
            
            Spacer()
            
            Spacer()
    
            Button(action: onNext) {
                Text(buttonText)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 30)
            }
            
        }
    }
}

#Preview {
    TutorialPage(title: "title", subtitle: "subtitle", description: "description", buttonText: "buttonText", onNext: {})
}
