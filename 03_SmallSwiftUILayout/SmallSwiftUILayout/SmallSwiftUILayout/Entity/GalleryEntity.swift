//
//  GalleryEntity.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct GalleryEntity: Decodable {

    let id: Int
    let title: String
    let summary: String
    let imageName: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
        case summary
        case imageName = "image_name"
    }

    // MARK: - Initializer

    init(id: Int, title: String, summary: String, imageName: String) {
        self.id = id
        self.title = title
        self.summary = summary
        self.imageName = imageName
    }

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.imageName = try container.decode(String.self, forKey: .imageName)
    }
}
