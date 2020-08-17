//
//  ContentView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/16.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        //
        TabView {

            //
            FindScreenView()
                .tabItem {
                    //
                    VStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Find")
                    }
                }.tag(1) //

            //
            GalleryScreenView()
                .tabItem {
                    //
                    VStack {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                        Text("Gallery")
                    }
                }.tag(1) //

            //
            ProfileScreenView()
                .tabItem {
                    //
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                }.tag(2) //

        }.accentColor(Color(hex: 0xff803a)) //
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
