//
//  PasscodeLockConstant.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: パスコードロック機能で利用する定数値
struct PasscodeLockConstant {

    // MARK: - Computed Property

    static var passcodeHashValue: String {
        return get("PasscodeSalt") as! String
    }

    // MARK: - Static Function

    static func get(_ key: String) -> AnyObject? {
        return Bundle.main.object(forInfoDictionaryKey: key) as AnyObject
    }
}
