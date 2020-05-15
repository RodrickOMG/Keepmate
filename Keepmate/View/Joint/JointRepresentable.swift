//
//  JointViewControllerRepresentable.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/5/7.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import Foundation
import SwiftUI

// Need UIViewControllerRepresentable to show any UIViewController in SwiftUI
struct CameraView : UIViewControllerRepresentable {
    @Binding var title: String
    @Binding var isBegin: Bool
    @Binding var isFinished: Bool
    @Binding var desiredGoal: Int
    @Binding var currentNum: Int
    @Binding var progressValue: Double
    @Binding var score: Int
    
    // Init your ViewController
    
    func makeUIViewController(context: Context) -> JointViewController {
        let controller = JointViewController()
        controller.name = title
        controller.desiredGoal = desiredGoal
        controller.delegate = context.coordinator
        return controller
    }
    
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: JointViewController, context: Context) {
        if isBegin {
            uiViewController.begin()
        } else {
            uiViewController.pause()
        }
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(isFinished: $isFinished, currentNum: $currentNum, desiredGoal: $desiredGoal, progressValue: $progressValue, score: $score)
    }
}

extension CameraView {
    class Coordinator: NSObject, CameraViewDelegate {

        @Binding var isFinished: Bool
        @Binding var currentNum: Int
        @Binding var desiredGoal: Int
        @Binding var progressValue: Double
        @Binding var score: Int
        
        init(isFinished: Binding<Bool>, currentNum: Binding<Int>, desiredGoal: Binding<Int>, progressValue: Binding<Double>, score: Binding<Int>) {
            _isFinished = isFinished
            _currentNum = currentNum
            _desiredGoal = desiredGoal
            _progressValue = progressValue
            _score = score
        }
        
        func CameraViewDidFinished(_ viewController: JointViewController) {
            isFinished = viewController.finishFlag
            score = viewController.score
        }
        
        func OneGroupDidFinished(_ viewController: JointViewController) {
            currentNum = viewController.successCount
            progressValue = Double(currentNum) / Double(desiredGoal)
        }
        
        func ConfirmDesiredGoal(_ viewController: JointViewController) {
            viewController.desiredGoal = desiredGoal
        }
        
    }
}

