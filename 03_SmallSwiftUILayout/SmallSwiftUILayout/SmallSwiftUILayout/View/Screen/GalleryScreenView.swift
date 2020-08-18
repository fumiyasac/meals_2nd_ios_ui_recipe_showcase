//
//  GalleryScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/17.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct GalleryScreenView: View {

    // MARK: - Property

    // Viewを表示するためのデータ値
    @State private var galleries: [GalleryEntity] = GalleryFactory.getGalleryEntities()

    // MARK: - body

    var body: some View {

        // NavigationViewを配置する
        NavigationView {

            // 初期値となるデータを与えてView要素を組み立てる
            GalleryGrid(galleries: $galleries)
                // NavigationBarのタイトル表示の設定
                .navigationBarTitle(Text("Gallery"), displayMode: .inline)
        }
        // NavigationViewでNavigationBarを表示する
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GalleryScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryScreenView()
    }
}
