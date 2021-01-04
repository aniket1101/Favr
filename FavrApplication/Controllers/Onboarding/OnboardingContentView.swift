//
//  OnboardingContentView.swift
//  Favr
//
//  Created by Aniket Gupta on 02/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import SwiftUI
import NotificationCenter

struct OnboardingContentView: View {
    
    @State private var step = 1
    @Environment(\.presentationMode) private var isPresented
    
    var body: some View {
        ZStack {
            Color("FavrOrange")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 15) {
//                Text("Welcome to")
//                    .font(.largeTitle)
//                    .foregroundColor(Color("FavrLightShade"))
//                    .padding(.top)
//                Text("Favr")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(Color("FavrLightShade"))
                
                
                GeometryReader { gr in
                    HStack {
                        VStack(spacing: 40) {
                            Image("OnboardingLogo").padding(80)
                            Text("Start being a better you")
                                .padding()
                                .animation(Animation.interpolatingSpring(stiffness: 40, damping: 7).delay(0.1))
                        }.frame(width: gr.frame(in: .global).width)
                        VStack(spacing: 40) {
                            Image("OnboardingDeeds").padding(80)
                            Text("Complete good deeds every day to earn points")
                                .padding()
                                .fixedSize(horizontal: false, vertical: true)
                                .animation(Animation.interpolatingSpring(stiffness: 40, damping: 7).delay(0.1))
                        }.frame(width: gr.frame(in: .global).width)
                        VStack(spacing: 40) {
                            Image("OnboardingChats").padding(80)
                            Text("Chat with your friends")
                                .padding()
                                .fixedSize(horizontal: false, vertical: true)
                                .animation(Animation.interpolatingSpring(stiffness: 40, damping: 7).delay(0.1))
                        }.frame(width: gr.frame(in: .global).width)
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("FavrLightShade"))
                    .font(.title)
                    .padding(.vertical, 60)
                    .frame(width: gr.frame(in: .global).width * 4)
                    .frame(maxHeight: .infinity)
                        
                    .offset(x: self.step == 1 ? gr.frame(in: .global).width : self.step == 2 ? 0 : -gr.frame(in: .global).width)
                    .animation(Animation.interpolatingSpring(stiffness: 40, damping: 8))
                }
                HStack (spacing: 20) {
                    Button(action: {self.step = 1}) {
                        Image(systemName: "1.circle")
                            .padding()
                            .scaleEffect(step == 1 ? 1:0.65)
                    }
                    Button(action: {self.step = 2}) {
                        Image(systemName: "2.circle")
                            .padding()
                            .scaleEffect(step == 2 ? 1:0.65)
                    }
                    Button(action: {self.step = 3}) {
                        Image(systemName: "3.circle")
                            .padding()
                            .scaleEffect(step == 3 ? 1:0.65)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.5))
                .font(.largeTitle)
                .accentColor(Color("LightAccent"))
//                self.isPresented.wrappedValue.dismiss()
                Button(action: {NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
}) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)
                    .padding()
                    .background(Capsule().fill(Color("FavrOnboardingOrange"))).accentColor(Color("LightAccent"))
                    .opacity(step == 3 ? 1:0)
                    .animation(.none)
                    .scaleEffect(step == 3 ? 1: 0.01).animation(Animation.interpolatingSpring(stiffness: 50, damping: 10, initialVelocity: 10))
                }
            }
        }
    }
}

struct OnboardingContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
