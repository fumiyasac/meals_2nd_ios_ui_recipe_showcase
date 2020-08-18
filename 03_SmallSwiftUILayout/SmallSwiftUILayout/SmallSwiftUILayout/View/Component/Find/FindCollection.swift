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

    @Binding var findScreenDataList: [FindScreenData]

    // MARK: - body

    var body: some View {
        
        ASCollectionView(sections: self.sections)
            .layout(self.layout)
            .shouldAttemptToMaintainScrollPositionOnOrientationChange(maintainPosition: false)
            .edgesIgnoringSafeArea(.all)
    }

    var sections: [ASCollectionViewSection<Int>] {

//        var sectionList: [ASCollectionViewSection<Int>] = []
//        for (sectionID, sectionData) in findScreenDataList.enumerated() {
//            let section = ASCollectionViewSection(id: sectionID, data: sectionData.entities, onCellEvent: nil) { entity, _ in
//                if sectionID == 0 && entity is FeaturedContentsEntity {
//                    FeaturedContentsComponentView(featuredContents: entity as! FeaturedContentsEntity)
//                } else if sectionID == 1 && entity is RecentStoryEntity {
//                    RecentStoryComponentView(recentStory: entity as! RecentStoryEntity)
//                }
//            }
//            sectionList.append(section)
//        }
//        return sectionList
        
        
        findScreenDataList.enumerated().map { (sectionID, sectionData) -> ASCollectionViewSection<Int> in
            ASCollectionViewSection(id: sectionID, data: sectionData.entities, onCellEvent: nil) { entity, _ in
                if sectionID == 0 && entity is FeaturedContentsEntity {
                    FeaturedContentsComponentView(featuredContents: entity as! FeaturedContentsEntity)
                } else if sectionID == 1 && entity is RecentStoryEntity {
                    RecentStoryComponentView(recentStory: entity as! RecentStoryEntity)
                }
            }
        }
    }
}

extension FindCollection {

    var layout: ASCollectionLayout<Int> {

        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 0) { sectionID in

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
                    return section
                    
                    
//                    let columnsToFit = floor(environment.container.effectiveContentSize.width / 320)
//                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1.0),
//                        heightDimension: .fractionalHeight(1.0)))
//
//                    let itemsGroup = NSCollectionLayoutGroup.vertical(
//                        layoutSize: NSCollectionLayoutSize(
//                            widthDimension: .fractionalWidth(0.8 / columnsToFit),
//                            heightDimension: .absolute(280)),
//                        subitem: item, count: 1)
//
//                    let section = NSCollectionLayoutSection(group: itemsGroup)
//                    section.interGroupSpacing = 20
//                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//                    section.orthogonalScrollingBehavior = .groupPaging
//                    section.visibleItemsInvalidationHandler = { _, _, _ in } // If this isn't defined, there is a bug in UICVCompositional Layout that will fail to update sizes of cells

                }
            case 1:
                return ASCollectionLayoutSection { _ in
                    
                    // MEMO: 該当のセルを基準にした高さの予測値を設定する
                    let estimatedHeight = UIScreen.main.bounds.width + 180.0

                    // 1. Itemのサイズ設定
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = .zero

                    // 2. Groupのサイズ設定
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    group.contentInsets = .zero

                    // 3. Sectionのサイズ設定
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(34)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                    header.contentInsets.leading = group.contentInsets.leading
                    header.contentInsets.trailing = group.contentInsets.trailing
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.boundarySupplementaryItems = [header]
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

//struct FindCollection_Previews: PreviewProvider {
//    static var previews: some View {
//        FindCollection()
//    }
//}
