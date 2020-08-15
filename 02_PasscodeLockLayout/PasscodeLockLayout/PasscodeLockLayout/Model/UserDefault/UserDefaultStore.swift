//
//  UserDefaultStore.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

// MEMO: ProperyWrapperを利用したUserDefaultの取り扱い
// 参考: https://www.amity.co/engineering-at-amity/learn-how-to-use-property-wrappers-in-swift-in-10-minutes

@propertyWrapper
struct UserDefaultStore<T> {

    // MARK: - Property

    // UserDefaultで利用するKey名
    var key: String

    // UserDefaultで利用するデフォルト値
    var defaultValue: T

    // MEMO: GetterとSetterの様な感じの定義
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.value(forKey: key) as? T ?? defaultValue }
    }

    // MARK: - Property

    // MEMO: Keyとデフォルト値を利用して初期化を実施する
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
