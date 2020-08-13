//
//  StringExtension.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

extension String {

    // MARK: - Function

    // 文字列をHMAC-SHA256化するための処理
    // パスコードをUserDefaultへ保存する際にはそのまま4桁の数値の文字列として保存しておくのではなく難読化するための対応
    // 参考: https://dishware.sakura.ne.jp/swift/archives/181
    func hmac(algorithm: CryptoAlgorithm) -> String {

        let key: String = PasscodeLockConstant.passcodeHashValue
        var result: [CUnsignedChar]
        if let ckey = key.cString(using: String.Encoding.utf8), let cdata = self.cString(using: String.Encoding.utf8) {
            result = Array(repeating: 0, count: Int(algorithm.digestLength))
            CCHmac(algorithm.HMACAlgorithm, ckey, ckey.count - 1, cdata, cdata.count - 1, &result)
        } else {
            return ""
        }
        let hash = NSMutableString()
        for val in result {
            hash.appendFormat("%02hhx", val)
        }
        return hash as String
    }
}
