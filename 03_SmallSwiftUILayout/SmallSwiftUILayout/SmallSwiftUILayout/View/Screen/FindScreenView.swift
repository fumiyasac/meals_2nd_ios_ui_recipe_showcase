//
//  FindScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

// MARK: - Typealias

struct FindScreenView: View {

    // MARK: - Property
    
    // Viewを表示に必要なデータ値
    @State private var findScreenDataList: [[FindEntity]] = FindFactory.getFindScreenDataList()
    
    // MARK: - body

    var body: some View {

        // NavigationViewを配置する
        NavigationView {

            // 初期値となるデータを与えてView要素を組み立てる
            FindCollection(findScreenDataList: $findScreenDataList)
                // NavigationBarのタイトル表示の設定
                .navigationBarTitle(Text("Find"), displayMode: .inline)
        }
        // NavigationViewでNavigationBarを表示する
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FindScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FindScreenView()
    }
}
