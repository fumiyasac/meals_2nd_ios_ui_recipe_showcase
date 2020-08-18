//
//  FindCollection.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI
import ASCollectionView

// MEMO: このライブラリに収録されているDemoアプリを参考に作成しています。
// → レイアウト構築バリエーションが豊富！
// https://github.com/apptekstudios/ASCollectionView

struct FindCollection: View {

    // MARK: - Property

    // Viewを表示に必要なデータ
    @Binding var findScreenDataList: [[FindEntity]]

    // MARK: - body

    var body: some View {

        // ライブラリ「ASCollectionView」を利用したViewを構築する
        // → 引数にはデータから生成したセクション要素を設定する
        ASCollectionView(sections: self.sections)
            // 構築したレイアウトを設定する
            // MEMO: 内部ではUICollectionViewを利用している
            .layout(self.layout)
            // SafeAreaを越えてコンテンツを表示する
            .edgesIgnoringSafeArea(.all)
    }

    // MEMO: データを元にしてセクション要素を組み立てる
    var sections: [ASCollectionViewSection<Int>] {

        // MEMO: 配列の中に更に配列がある形のデータなのでその順番(index値)がセクション値となる
        findScreenDataList.enumerated().map { (sectionID, findEntities) -> ASCollectionViewSection<Int> in

            // セクション要素を構築する
            ASCollectionViewSection(id: sectionID, data: findEntities, onCellEvent: nil) { findEntity, _ in

                if sectionID == 0 && findEntity is FeaturedContentsEntity {

                    // MEMO: FeaturedContentsEntityを表示するView要素に与える
                    FeaturedContentsComponentView(featuredContents: findEntity as! FeaturedContentsEntity)

                } else if sectionID == 1 && findEntity is RecentStoryEntity {

                    // MEMO: RecentStoryEntityを表示するView要素に与える
                    RecentStoryComponentView(recentStory: findEntity as! RecentStoryEntity)
                }
            }
        }
    }
}

// MARK: - Extension

extension FindCollection {

    // ASCollectionViewのレイアウトを組み立てる
    // MEMO: ここではUICollectionViewCompositionalLayoutのレイアウト定義を設定する
    // → 従来通りのUICollectionViewのレイアウトクラスを利用することも可能
    var layout: ASCollectionLayout<Int> {

        // セクション値に応じたASCollectionLayoutの構築をする
        ASCollectionLayout(scrollDirection: .vertical) { sectionID in

            switch sectionID {

            // MEMO: 左右にスクロール切り替え可能なCarousel型のレイアウト
            case 0:

                return ASCollectionLayoutSection { _ in

                    // 1. Itemのサイズ設定
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = .zero

                    // 2. Groupのサイズ設定
                    // MEMO: 1列に表示するカラム数を1として設定し、itemのサイズがgroupのサイズで決定する形にしている
                    let groupHeight = UIScreen.main.bounds.width * (2 / 3)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHeight))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                    group.contentInsets = .zero

                    // 3. Sectionのサイズ設定
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
                    // MEMO: スクロール終了時に水平方向のスクロールが可能で中心位置で止まる
                    section.orthogonalScrollingBehavior = .groupPagingCentered
                    section.visibleItemsInvalidationHandler = { _, _, _ in }

                    return section
                }

            // MEMO: 表示する文字の長さに応じて高さが可変となるレイアウト
            case 1:

                return ASCollectionLayoutSection { _ in
                    
                    // MEMO: 該当のセルを基準にした高さの予測値を設定する
                    let estimatedHeight = UIScreen.main.bounds.width * (2 / 3)

                    // 1. Itemのサイズ設定
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = .zero

                    // 2. Groupのサイズ設定
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    group.contentInsets = .zero

                    // 3. Sectionのサイズ設定
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                    section.visibleItemsInvalidationHandler = { _, _, _ in }

                    return section
                }

            default:
                fatalError("ここはSectionは2つだけなので通らない想定")
            }
        }
    }
}
