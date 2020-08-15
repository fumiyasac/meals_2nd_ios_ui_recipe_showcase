//
//  StockModel.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

class StockModel: Object {

    // MARK: - Properry

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var alreadyPassTutorial = false

    // MARK: - Override

    override static func primaryKey() -> String? {
        return "id"
    }
}
