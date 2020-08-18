//
//  RecentStoryComponentView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct RecentStoryComponentView: View {

    // MARK: - Property

    private let regularFontName = "AvenirNext-Regular"
    private let boldFontName = "AvenirNext-Bold"

    let recentStory: RecentStoryEntity

    // MARK: - body

    var body: some View {

        //
        VStack(alignment: .leading) {

            //
            Text(recentStory.userName)
                .font(.custom(boldFontName, size: 14))
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding([.leading, .trailing], 8)
            Text(recentStory.publishedDate)
                .font(.custom(regularFontName, size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding([.leading, .trailing], 8)
                .padding(.top, 4)
            Image(recentStory.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .padding(8)
            Text(recentStory.description)
                .font(.custom(regularFontName, size: 12))
                .foregroundColor(.primary)
                .padding(8)
        }
        .padding(.bottom, 28)
    }
}

struct RecentStoryComponentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentStoryComponentView(
            recentStory: RecentStoryEntity(
                recentStoryId: 1,
                userName: "登録ユーザーその1",
                publishedDate: "2020.08.18",
                imageName: "recent1",
                description: "野菜多めと合わせ味噌が決め手の豚汁は本当にいつも重宝しております。忙しくってなかなか料理をする時間がない時も本当に助かっています✨✨"
            )
        )
    }
}
