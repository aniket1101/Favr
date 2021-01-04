//
//  ContentView.swift
//  Favr
//
//  Created by Aniket Gupta on 01/09/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var step = 1

    var body: some View {
        ZStack {
            Color("FavrOrange")
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
