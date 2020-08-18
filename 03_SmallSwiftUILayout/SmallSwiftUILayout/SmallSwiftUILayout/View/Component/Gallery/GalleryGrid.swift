//
//  GalleryGrid.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI
import WaterfallGrid

// MEMO: SwiftUIでもPinterestの様なレイアウトを実現する
// → 従来のUICollectionViewでも難しい表現の1つ
// https://github.com/paololeonardi/WaterfallGrid

struct GalleryGrid: View {

    // MARK: - Property

    // Viewを表示に必要なデータ
    @Binding var galleries: [GalleryEntity]

    // MARK: - body

    var body: some View {

        // データを元にして表示要素を組み立てる
        return WaterfallGrid((0..<galleries.count), id: \.self) { index in

            // MEMO: GalleryEntityを表示するView要素に与える
            GalleryComponentView(gallery: self.galleries[index])
        }
        // グリッド要素に関するスタイル設定
        .gridStyle(
            columnsInPortrait: 2,
            columnsInLandscape: 4,
            spacing: 8,
            padding: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            animation: .default
        )
        // スクロール時のIndicator表示の有無
        .scrollOptions(showsIndicators: true)
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
