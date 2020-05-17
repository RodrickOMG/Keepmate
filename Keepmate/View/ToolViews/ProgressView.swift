//
//  ProcessView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/7.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressView: UIViewRepresentable {
    @Binding var currentNum: Int
    @Binding var desiredGoal: Int
    
    func makeUIView(context: Context) -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.green
        progressView.trackTintColor = UIColor.yellow
        return progressView
    }
    
    func updateUIView(_ uiView: UIProgressView, context: Context) {
        uiView.setProgress(Float(currentNum / desiredGoal), animated: true)
    }
}
