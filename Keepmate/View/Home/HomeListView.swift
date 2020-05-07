//
//  HomeListView.swift
//  Keepmate
//
//  Created by Rodrick Dai on 2020/1/16.
//  Copyright © 2020 Rodrick Dai. All rights reserved.
//

import SwiftUI

struct HomeListView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Keepmate")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color("Font1"))
                        Text("22 courses")
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                }
                .padding(.leading, 70.0)
                WorkoutCardScrollView()
            }
            .padding(.top, 78.0)
        }
    }
}

struct WorkoutCardView: View {
    var text = "Biceps Curl"
    var image = "Biceps_Curl_Person"
    var backgroundColor = Color("background3")
    var backgroundShadowColor = Color("backgroundShadow3")
    @State var isDetailPresented = false
    var body: some View {
        NavigationLink(destination: WorkoutDetailView(title: .constant(self.text), isPresented: $isDetailPresented), isActive: $isDetailPresented) {
            Button(action: {
                print(self.text)
                self.isDetailPresented.toggle()
            }) {
                VStack(alignment: .center) {
                    Text(text)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .padding(.top, 30)
                        .padding(.horizontal)
                        .frame(width: 240)
                    Spacer()
                    Image(image)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 30)
                }
                .background(backgroundColor)
                .cornerRadius(30)
                .shadow(color: backgroundShadowColor, radius: 20, x: 0, y: 20)
                .frame(width: 240, height: 340)
            }
        }
    }
}

struct WorkoutCardScrollView: View {
    @State var isDetailPresented = false
    var workout = workoutItemData
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(workout) { item in
                    WorkoutCardView(text: item.title, image: item.imageName, backgroundColor: item.backgroundColor, backgroundShadowColor: item.backgroundShadowColor)
                        .padding(5)
                }
                
            }
            .padding([.horizontal, .bottom])
            .frame(height: 420)
        }
    }
}



let workoutItemData = [
    WorkoutItemCard(title: "Biceps Curl", imageName: "Biceps_Curl_Person", backgroundColor: Color("background3"), backgroundShadowColor: Color("backgroundShadow3")),
    WorkoutItemCard(title: "Cossack Squat", imageName: "Cossack_Squat_Person", backgroundColor: Color("background2"), backgroundShadowColor: Color("backgroundShadow2")),
    WorkoutItemCard(title: "Push-up", imageName: "Push-up_Person", backgroundColor: Color("background1"), backgroundShadowColor: Color("backgroundShadow1")),
    WorkoutItemCard(title: "Dumbbell Shoulder Press", imageName: "Dumbbell_Shoulder_Press_Person", backgroundColor: Color("background4"), backgroundShadowColor: Color("backgroundShadow4")),
]

#if DEBUG
struct HomeListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            HomeListView().previewDevice("iPhone Xs Max")
            HomeListView().previewDevice("iPhone 11 Pro")
            HomeListView().previewDevice("iPhone 11")
                .environment(\.colorScheme, .dark)
            HomeListView().previewDevice("iPhone 8")
        }
    }
}
#endif
