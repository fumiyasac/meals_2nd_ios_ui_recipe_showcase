//
//  GalleryComponentView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct GalleryComponentView: View {

    // MARK: - Property

    private let regularFontName = "AvenirNext-Regular"
    private let boldFontName = "AvenirNext-Bold"

    let gallery: GalleryEntity

    // MARK: - body

    var body: some View {

        //
        VStack {
            
            //
            Image(gallery.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .layoutPriority(97)

            //
            HStack {

                //
                VStack(alignment: .leading) {

                    //
                    Text(gallery.title)
                        .font(.custom(boldFontName, size: 14))
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(98)

                    //
                    Text(gallery.summary)
                        .font(.custom(regularFontName, size: 12))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(99)
                }
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(4)
        .background(
            RoundedRectangle(cornerRadius: 4).stroke(Color.secondary.opacity(0.5))
        )
    }
}

struct GalleryComponentView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryComponentView(
            gallery: GalleryEntity(
                id: 1,
                title: "朝食にゆっくりと味わって食べたいサンドイッチ",
                summary: "気持ち良い朝の目覚めにぴったり。ルノアールのサンドイッチが食べたいなぁ。",
                imageName: "sample1"
            )
        )
    }
}
