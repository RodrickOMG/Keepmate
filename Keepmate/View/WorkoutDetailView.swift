//
//  WorkoutDetailView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/24.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI


// Need UIViewControllerRepresentable to show any UIViewController in SwiftUI
struct CameraView : UIViewControllerRepresentable {
    @Binding var bodyPoints: [PredictedPoint?]
    // Init your ViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = JointViewController()
        return controller
    }
    
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {

    }
}

//
struct DrawingView: UIViewRepresentable {
    
    @Binding var bodyPoints: [PredictedPoint?]
    
    func makeUIView(context: UIViewRepresentableContext<DrawingView>) -> DrawingJointView {
        let DrawingView = DrawingJointView()
        return DrawingView
    }
    
    func updateUIView(_ uiView: DrawingJointView, context: UIViewRepresentableContext<DrawingView>) {
    }
    
}

struct WorkoutDetailView: View {
    @Binding var title: String
    @Binding var isPresented: Bool
    @Binding var bodyPoints: [PredictedPoint?]
    @State var viewState = CGSize.zero // position
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack {
                Text(title)
                    .font(.title)
                HStack{
                  Text("Video")
                    .font(.title)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                ZStack {
                    CameraView(bodyPoints: $bodyPoints)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    //DrawingView(bodyPoints: $bodyPoints)
                }
                
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(title)
            .gesture(  // swipe to back
                DragGesture()
                    .onChanged { value in
                        self.viewState = value.translation
                }
                .onEnded { value in
                    if self.viewState.width > 0 && abs(self.viewState.height) < 50{
                        self.viewState = CGSize.zero
                        self.isPresented.toggle()
                    }
                    self.viewState = CGSize.zero
                }
        )
    }
}



struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(title: .constant("push-up"), isPresented: .constant(true), bodyPoints: .constant([]))
    }
}
