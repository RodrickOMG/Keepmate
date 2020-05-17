//
//  WorkoutDetailView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/2/24.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI
import AVFoundation


struct WorkoutDetailView: View {
    @Binding var title: String
    @Binding var isPresented: Bool
    @State var viewState = CGSize.zero // position
    @State var timeRemaining = 5
    @State var isTimeUp = false
    @State var isTimeLabelPresented = false
    @State var isBegin = false
    @State var isFinished = false
    @State var desiredGoal = 10
    @State var currentNum = 0
    @State var progressValue = 0.0
    
    @State var score = 80
    
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
                    PlayerView(title: $title, isBegin: $isBegin, isFinished: $isFinished)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 220)
                    HStack {
                        ProgressBar(value: $progressValue)
                        Text("\(self.currentNum) / \(self.desiredGoal)")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
                    .offset(x: 0, y: -15)
                    
                    CameraView(title: $title, isBegin: $isBegin, isFinished: $isFinished, desiredGoal: $desiredGoal, currentNum: $currentNum, progressValue: $progressValue, score: $score)
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
            workoutIntroductionCard(title: $title, isTimeLabelPresented: $isTimeLabelPresented, desiredGoal: $desiredGoal)
                .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 400)
                .padding()
                .padding(.horizontal)
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(30)
                .shadow(radius: 20)
                .opacity(isTimeLabelPresented || isBegin ? 0 : 1)
            finishCard(title: $title, isPresented: $isPresented, score: $score, count: $desiredGoal )
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
    @Binding var desiredGoal: Int
    var stepText: String
    var motionFeelingText: String
    
    init(title: Binding<String>, isTimeLabelPresented: Binding<Bool>, desiredGoal: Binding<Int>) {
        _title = title
        _isTimeLabelPresented = isTimeLabelPresented
        _desiredGoal = desiredGoal
        let titleStr = title.wrappedValue
        let path = Bundle.main.path(forResource: "\(titleStr)", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        stepText = data!["Step"] as! String
        motionFeelingText = data!["Motion Feeling"] as! String
    }
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.title)
                    .foregroundColor(Color("systemFont"))
                Text("Step")
                    .font(.headline)
                    .foregroundColor(Color("systemFont"))
                Text(stepText)
                    .font(.body)
                    .foregroundColor(Color("systemFont"))
                Text("Motion feeling")
                    .font(.headline)
                    .foregroundColor(Color("systemFont"))
                Text(motionFeelingText)
                    .font(.body)
                    .foregroundColor(Color("systemFont"))
                Text("Desired amount of \(title)")
                    .font(.headline)
                    .lineLimit(nil)
                Stepper(value: $desiredGoal, in: 3...80, step: 1) {
                    Text("\(self.desiredGoal)")
                }
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

struct finishCard: View {
    @Binding var title: String
    @Binding var isPresented: Bool
    @Binding var score: Int
    @Binding var count: Int
    var body: some View {
        VStack {
            Image("good_job")
                .resizable()
                .scaledToFill()
            HStack {
                Text("Finish \(count)")
                    .font(.custom("Chalkboard SE", size: 18))
                Text("\(title)s")
                    .font(.custom("Chalkboard SE", size: 20))
                    .bold()
            }
            .offset(y: -40)
            Text("Score:  \(score)")
                .font(.custom("Chalkboard SE", size: 22))
                .offset(y: -40)
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
    }
}

struct ProgressBar: View {
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: geometry.size.width * 0.9 , height: geometry.size.height * 0.3)
                        .opacity(0.4)
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width * 0.9, geometry.size.width), height: geometry.size.height * 0.3)
                        .foregroundColor(Color("LightBtnBkg1"))
                        .animation(.linear)
                }.cornerRadius(45.0)
            }
        }
    }
}



struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(title: .constant("push-up"), isPresented: .constant(true))
    }
}
