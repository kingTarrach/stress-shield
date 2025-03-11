//
//  AICoachView.swift
//  StressShield
//
//  Created by Camden Dowhaniuk on 1/18/25.
//

import UIKit
import SwiftUI
import WebKit

struct AICoachView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    AICoachView(url: URL(string: "https://app.coachvox.ai/avatar/HhVpxzXud6ZD3Yiw9AQf/fullscreen")!)
        .edgesIgnoringSafeArea(.all)
}
