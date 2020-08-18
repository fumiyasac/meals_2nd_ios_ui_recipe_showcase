//
//  ContentView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/16.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

// MEMO: このサンプルではおおもとをこのViewに設定しています。

struct ContentView: View {

    // MARK: - body

    var body: some View {

        // TabViewを利用してUITabBarControllerの様な表示をする
        TabView {

            // FindScreenView()の表示とタブ要素の連携
            FindScreenView()
                .tabItem {

                    // UITabBarItemの様なタブ要素
                    VStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Find")
                    }
                }
                // タグ値: 0
                .tag(0)

            // GalleryScreenView()の表示とタブ要素の連携
            GalleryScreenView()
                .tabItem {

                    // UITabBarItemの様なタブ要素
                    VStack {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                        Text("Gallery")
                    }
                // タグ値: 1
                }.tag(1)

            // ProfileScreenView()の表示とタブ要素の連携
            ProfileScreenView()
                .tabItem {

                    // UITabBarItemの様なタブ要素
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                // タグ値: 2
                }.tag(2)

        }
        // アクティブなタブの配色
        .accentColor(Color(hex: 0xff803a))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
