//
//  GalleryFactory.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

final class GalleryFactory {
    
    // MARK: - Static Function

    static func getGalleryEntities() -> [GalleryEntity] {
        // JSONファイルから表示用のデータを取得する
        guard let path = Bundle.main.path(forResource: "gallery", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let galleryEntities = try? JSONDecoder().decode([GalleryEntity].self, from: data) else {
            fatalError()
        }
        return galleryEntities
    }
}
