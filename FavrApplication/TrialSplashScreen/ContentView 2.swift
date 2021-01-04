//
//  ContentView.swift
//  Favr
//
//  Created by Aniket Gupta on 25/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @State var showSplash = true
  
  var body: some View {
    ZStack{
      MapView(coordinate: CLLocationCoordinate2DMake(37.331820, -122.03118))
        .edgesIgnoringSafeArea(.all)
      SplashScreen()
        .opacity(showSplash ? 1 : 0)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SplashScreen.shouldAnimate = false
            withAnimation() {
              self.showSplash = false
            }
          }
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
