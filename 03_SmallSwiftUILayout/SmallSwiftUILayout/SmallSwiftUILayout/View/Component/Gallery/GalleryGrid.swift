//
//  GalleryGrid.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI
import WaterfallGrid

// MEMO: ライブラリ「ASCollectionView」でも同様のことが実現できます。

struct GalleryGrid: View {

    // MARK: - Property

    @Binding var galleries: [GalleryEntity]

    // MARK: - body

    var body: some View {

        //
        let displayRange = (0..<galleries.count)

        //
        return WaterfallGrid(displayRange, id: \.self) { index in
            GalleryComponentView(gallery: self.galleries[index])
        }
        .gridStyle(
            columnsInPortrait: 2,
            columnsInLandscape: 4,
            spacing: 8,
            padding: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            animation: .default
        ) //
        .scrollOptions(showsIndicators: true) //
    }
}

struct GalleryGrid_Previews: PreviewProvider {

    static let previewGalleries = [
        GalleryEntity(
            id: 1,
            title: "朝食にゆっくりと味わって食べたいサンドイッチ",
            summary: "気持ち良い朝の目覚めにぴったり。ルノアールのサンドイッチが食べたいなぁ。",
            imageName: "sample1"
        ),
        GalleryEntity(
            id: 2,
            title: "A5ランクの国産牛を使った最強のビーフステーキ",
            summary: "これこそまさに最高の贅沢。いいことがあったから今夜は食べよう。",
            imageName: "sample2"
        ),
        GalleryEntity(
            id: 3,
            title: "紹興酒との最高のおともになる中華料理の前菜",
            summary: "中華料理はいつも僕のテンションを上げてくれる。前菜だけでも魅力的である。",
            imageName: "sample3"
        ),
        GalleryEntity(
            id: 4,
            title: "サーモンとクリームチーズのクラッカー",
            summary: "生のチースは僕はとっても苦手ですが、サーモンとクリームチーズの組み合わせは好きです。",
            imageName: "sample4"
        )
    ]

    static var previews: some View {
        GalleryGrid(galleries: .constant(previewGalleries))
    }
}
