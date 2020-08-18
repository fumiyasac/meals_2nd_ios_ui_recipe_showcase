//
//  GalleryScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/17.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

struct GalleryScreenView: View {

    // MARK: - Property
    
    @State private var galleries: [GalleryEntity] = GalleryFactory.getGalleryEntities()

    // MARK: - body

    var body: some View {

        //
        NavigationView {

            //
            GalleryGrid(galleries: $galleries)
                .navigationBarTitle(Text("Gallery"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GalleryScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryScreenView()
    }
}
