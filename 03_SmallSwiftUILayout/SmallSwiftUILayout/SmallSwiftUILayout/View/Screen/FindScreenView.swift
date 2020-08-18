//
//  FindScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/18.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

// MARK: - Typealias

//
typealias FindScreenData = (sectionTitle: String, entities: [FindEntity])

struct FindScreenView: View {

    // MARK: - Property
    
    @State private var findScreenDataList: [FindScreenData] = FindFactory.getFindScreenDataList()
    
    // MARK: - body

    var body: some View {

        //
        NavigationView {

            //
            FindCollection(findScreenDataList: $findScreenDataList)
                .navigationBarTitle(Text("Find"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FindScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FindScreenView()
    }
}
