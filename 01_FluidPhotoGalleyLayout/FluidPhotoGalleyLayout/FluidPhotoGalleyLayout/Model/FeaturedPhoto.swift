//
//  FeaturedPhoto.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct FeaturedPhoto: Decodable {

    let id: Int
    let title: String
    let description: String
    let thumbnailName: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailName
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.thumbnailName = try container.decode(String.self, forKey: .thumbnailName)
    }
}
