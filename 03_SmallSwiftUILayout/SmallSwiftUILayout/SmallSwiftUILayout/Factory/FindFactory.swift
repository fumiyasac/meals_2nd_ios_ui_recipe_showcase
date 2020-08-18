//
//  FindFactory.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

final class FindFactory {
    
    // MARK: - Static Function

    static func getFindScreenDataList() -> [FindScreenData] {
        return [
            (sectionTitle: "⭐️特集コンテンツ", entities: getFeaturedContentsEntities()),
            (sectionTitle: "📝最近の注目投稿", entities: getRecentStoryEntities())
        ]
    }

    // MARK: - Static Function

    private static func getFeaturedContentsEntities() -> [FeaturedContentsEntity] {
        guard let path = Bundle.main.path(forResource: "featured_contents", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let featuredContentsEntities = try? JSONDecoder().decode([FeaturedContentsEntity].self, from: data) else {
            fatalError()
        }
        return featuredContentsEntities
    }

    private static func getRecentStoryEntities() -> [RecentStoryEntity] {
        guard let path = Bundle.main.path(forResource: "recent_story", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let recentStoryEntities = try? JSONDecoder().decode([RecentStoryEntity].self, from: data) else {
            fatalError()
        }
        return recentStoryEntities
    }
}
