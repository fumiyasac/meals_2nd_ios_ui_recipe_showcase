//
//  FindCollection.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct FindCollection: View {

    // MARK: - Property

    @Binding var findScreenDataList: [[FindEntity]]

    // MARK: - body

    var body: some View {
        
        ASCollectionView(sections: self.sections)
            .layout(self.layout)
            .shouldAttemptToMaintainScrollPositionOnOrientationChange(maintainPosition: false)
            .edgesIgnoringSafeArea(.all)
    }

    var sections: [ASCollectionViewSection<Int>] {

        //
        findScreenDataList.enumerated().map { (sectionID, findEntities) -> ASCollectionViewSection<Int> in
            ASCollectionViewSection(id: sectionID, data: findEntities, onCellEvent: nil) { findEntity, _ in
                if sectionID == 0 && findEntity is FeaturedContentsEntity {
                    FeaturedContentsComponentView(featuredContents: findEntity as! FeaturedContentsEntity)
                } else if sectionID == 1 && findEntity is RecentStoryEntity {
                    RecentStoryComponentView(recentStory: findEntity as! RecentStoryEntity)
                }
            }
        }
    }
}

// MARK: - Extension

extension FindCollection {

    //
    var layout: ASCollectionLayout<Int> {

        //
        ASCollectionLayout(scrollDirection: .vertical) { sectionID in
            switch sectionID {
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
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                    // MEMO: スクロール終了時に水平方向のスクロールが可能で中心位置で止まる
                    section.orthogonalScrollingBehavior = .groupPagingCentered
                    section.visibleItemsInvalidationHandler = { _, _, _ in }

                    return section
                }
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
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                    section.visibleItemsInvalidationHandler = { _, _, _ in }

                    return section
                }
            default:
                fatalError("ここはSectionは2つだけなので通らない想定")
            }
        }
    }
}
