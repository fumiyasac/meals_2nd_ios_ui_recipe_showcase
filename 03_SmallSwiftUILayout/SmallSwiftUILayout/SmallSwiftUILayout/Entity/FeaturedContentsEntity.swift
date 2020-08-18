//
//  FeaturedContentsEntity.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

//

class FeaturedContentsEntity: FindEntity, Decodable, Hashable {

    let featuredContentsId: Int
    let imageName: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case featuredContentsId = "featured_contents_id"
        case imageName = "image_name"
    }

    // MARK: - Initializer

    init(featuredContentsId: Int, imageName: String) {
        self.featuredContentsId = featuredContentsId
        self.imageName = imageName
    }

    required init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.featuredContentsId = try container.decode(Int.self, forKey: .featuredContentsId)
        self.imageName = try container.decode(String.self, forKey: .imageName)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(featuredContentsId)
    }

    static func == (lhs: FeaturedContentsEntity, rhs: FeaturedContentsEntity) -> Bool {
        return lhs.featuredContentsId == rhs.featuredContentsId
    }
}
