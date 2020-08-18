//
//  RecentStoryEntity.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

//

class RecentStoryEntity: FindEntity, Decodable, Hashable {

    let recentStoryId: Int
    let userName: String
    let publishedDate: String
    let imageName: String
    let description: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case recentStoryId = "recent_story_id"
        case userName = "user_name"
        case publishedDate = "published_date"
        case imageName = "image_name"
        case description
    }

    // MARK: - Initializer

    init(recentStoryId: Int, userName: String, publishedDate: String, imageName: String, description: String) {
        self.recentStoryId = recentStoryId
        self.userName = userName
        self.publishedDate = publishedDate
        self.imageName = imageName
        self.description = description
    }

    required init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.recentStoryId = try container.decode(Int.self, forKey: .recentStoryId)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.description = try container.decode(String.self, forKey: .description)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(recentStoryId)
    }

    static func == (lhs: RecentStoryEntity, rhs: RecentStoryEntity) -> Bool {
        return lhs.recentStoryId == rhs.recentStoryId
    }
}
