//
//  WorkoutDetailView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/24.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import AVFoundation


// Need UIViewControllerRepresentable to show any UIViewController in SwiftUI
struct CameraView : UIViewControllerRepresentable {
    @Binding var bodyPoints: [PredictedPoint?]
    @Binding var title: String
    @Binding var isBegin: Bool
    @Binding var isFinished: Bool
    // Init your ViewController
    
    func makeUIViewController(context: Context) -> JointViewController {
        let controller = JointViewController()
        controller.name = title
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
        return Coordinator(isFinished: $isFinished)
    }
}

extension CameraView {
    class Coordinator: NSObject, CameraViewDelegate {
        @Binding var isFinished: Bool
        
        init(isFinished: Binding<Bool>) {
            _isFinished = isFinished
        }
        
        func CameraViewDidFinished(_ viewController: JointViewController) {
            isFinished = viewController.finishFlag
        }
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

// video player
struct PlayerView: UIViewRepresentable {
    @Binding var isBegin: Bool
    @Binding var isFinished: Bool
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        if isBegin {
            uiView.beginPlayVideo()
        }
        if isFinished {
            uiView.stopPlayVideo()
        }
    }
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(frame: .zero)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let mediaPath = Bundle.main.path(forResource: "Cossack Squat", ofType: "mp4")
        let mediaURL = URL(fileURLWithPath: mediaPath!)
        
        player = AVPlayer(url:mediaURL as URL)
        player.actionAtItemEnd = .none
        
        playerLayer.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        
        layer.addSublayer(playerLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    func beginPlayVideo() {
        player.play()
    }
    func stopPlayVideo() {
        player.pause()
    }
}

struct WorkoutDetailView: View {
    @Binding var title: String
    @Binding var isPresented: Bool
    @Binding var bodyPoints: [PredictedPoint?]
    @State var viewState = CGSize.zero // position
    @State var timeRemaining = 5
    @State var isTimeUp = false
    @State var isTimeLabelPresented = false
    @State var isBegin = false
    @State var isFinished = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // timer for countdown
    
    var body: some View {
        ZStack(alignment: .center){
            VStack {
                HStack {
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(Color("BackBtn1"))
                        
                    }.frame(width: 30, height: 30)
                    Spacer()
                    Text(title)
                        .font(.title)
                    Spacer()
                }
                VStack {
                    PlayerView(isBegin: $isBegin, isFinished: $isFinished)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 220)
                    HStack {
                        Text("test")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
                    .background(Color("mainBackgroundShadow"))
                    .offset(x: 0, y: -20)
                    
                    CameraView(bodyPoints: $bodyPoints, title: $title, isBegin: $isBegin, isFinished: $isFinished)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    
                    //DrawingView(bodyPoints: $bodyPoints)
                    
                }
                
                
            }
            .padding(.top, 20)
            .blur(radius: isTimeLabelPresented || !isBegin || isFinished ? 10 : 0)
            Text(isTimeUp ? "Begin" : "\(timeRemaining)")
                .font(.custom("Chalkboard SE", size: 40))
                .fontWeight(.bold)
                .padding()
                .frame(width: isTimeUp ? 150 : 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 4)
            )
                .background(Color("timerBkg"))
                .cornerRadius(20)
                .onReceive(timer) { _ in
                    if self.isTimeLabelPresented {
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        } else if self.timeRemaining == 0 {
                            self.isTimeUp = true
                            self.timeRemaining -= 1
                        } else {
                            self.isTimeLabelPresented = false
                            self.isBegin = true
                        }
                    }
            }
            .opacity(isTimeLabelPresented ? 1 : 0)
            workoutIntroductionCard(title: $title, isTimeLabelPresented: $isTimeLabelPresented)
                .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 400)
                .padding()
                .padding(.horizontal)
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(30)
                .shadow(radius: 20)
                .opacity(isTimeLabelPresented || isBegin ? 0 : 1)
            VStack {
                Text("Finish!")
                    .font(.largeTitle)
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    HStack(alignment: .center) {
                        Text("Done")
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: 100)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBtnBkg1"), Color("LightBtnBkg1")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                }
            }
            .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 300)
            .padding()
            .padding(.horizontal)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(30)
            .shadow(radius: 20)
            .animation(.easeIn(duration: 1))
            .offset(y: isFinished ? 40 : UIScreen.main.bounds.height)
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

struct workoutIntroductionCard: View {
    @Binding var title: String
    @Binding var isTimeLabelPresented: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.title)
                    .foregroundColor(Color("systemFont"))
                Text("Step")
                    .font(.headline)
                    .foregroundColor(Color("systemFont"))
                Text("·Feet about twice the width of the shoulders.\n·Squat to the left, straighten the right leg, pause slightly, keep the hips as high as possible, slowly translate to the right leg, squat, straighten the left.\n·Do not leave the ground with your feet on the whole course, cross your hands and put them on your chest.")
                    .font(.body)
                    .foregroundColor(Color("systemFont"))
                Text("Motion feeling")
                    .font(.headline)
                    .foregroundColor(Color("systemFont"))
                Text("·When squatting, the inside of the straight leg stretches.\n·When the body is translated, there is a sense of stretch on the inside of the thighs on both sides.")
                    .font(.body)
                    .foregroundColor(Color("systemFont"))
                Spacer()
                Button(action: {
                    self.isTimeLabelPresented.toggle()
                }) {
                    HStack(alignment: .center) {
                        Text("Begin")
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: 150)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBtnBkg1"), Color("LightBtnBkg1")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                }
            .offset(x: 65, y: 0)
            }
        }
    }
    
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(title: .constant("push-up"), isPresented: .constant(true), bodyPoints: .constant([]))
    }
}
