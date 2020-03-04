//
//  JointController.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/3/3.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import UIKit

struct WorkoutDetailViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<WorkoutDetailViewController>) -> UIViewController {
        let jointViewController = JointViewController()
        return jointViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WorkoutDetailViewController>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
}
