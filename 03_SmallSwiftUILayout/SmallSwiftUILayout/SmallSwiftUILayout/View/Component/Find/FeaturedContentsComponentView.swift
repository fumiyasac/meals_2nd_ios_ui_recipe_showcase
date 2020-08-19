//
//  FeaturedContentsComponentView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct FeaturedContentsComponentView: View {

    // MARK: - Property

    let featuredContents: FeaturedContentsEntity

    // MARK: - body

    var body: some View {

        // 表示画像
        Image(featuredContents.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct FeaturedContentsComponentView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedContentsComponentView(
            featuredContents: FeaturedContentsEntity(
                featuredContentsId: 1,
                imageName: "featured1"
            )
        )
    }
}
