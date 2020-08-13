//
//  PasscodeModel.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct PasscodeModel {

    // MARK: - Properry

    @UserDefaultStore(key: "UserHashedPasscode", defaultValue: "") private static var userHashedPasscode

    // MARK: - Static Function

    // ユーザーが入力したパスコードを保存する
    static func saveHashedPasscode(_ passcode: String) -> Bool {
        if isValid(passcode) {
            setHashedPasscode(passcode)
            return true
        } else {
            return false
        }
    }

    // ユーザーが入力したパスコードと現在保存されているパスコードを比較する
    static func compareSavedPasscodeWith(inputPasscode: String) -> Bool {
        let hashedInputPasscode = getHashedPasscodeByHMAC(inputPasscode)
        let savedPasscode = getHashedPasscode()
        return hashedInputPasscode == savedPasscode
    }

    // ユーザーが入力したパスコードが存在するかを判定する
    static func existsHashedPasscode() -> Bool {
        let savedPasscode = getHashedPasscode()
        return !savedPasscode.isEmpty
    }

    // HMAC形式でハッシュ化されたパスコード取得する
    static func getHashedPasscode() -> String {
        return userHashedPasscode
    }

    // 現在保存されているパスコードを削除する
    static func deleteHashedPasscode() {
        userHashedPasscode = ""
    }

    // MARK: - Private Static Function

    // 引数で受け取ったパスコードをhmacで暗号化した上で保存する
    private static func setHashedPasscode(_ passcode: String) {
        userHashedPasscode = getHashedPasscodeByHMAC(passcode)
    }

    // 引数で受け取った値をhmacで暗号化する
    private static func getHashedPasscodeByHMAC(_ passcode: String) -> String {
        return passcode.hmac(algorithm: .SHA256)
    }

    // 引数で受け取った値の形式が正しいかどうかを判定する
    private static func isValid(_ passcode: String) -> Bool {
        return isValidLength(passcode) && isValidFormat(passcode)
    }

    // 引数で受け取った値が4文字かを判定する
    private static func isValidLength(_ passcode: String) -> Bool {
        return passcode.count == 4
    }

    // 引数で受け取った値が半角数字かを判定する
    private static func isValidFormat(_ passcode: String) -> Bool {
        let regexp = try! NSRegularExpression.init(pattern: "^(?=.*?[0-9])[0-9]{4}$", options: [])
        let targetString = passcode as NSString
        let result = regexp.firstMatch(in: passcode, options: [], range: NSRange.init(location: 0, length: targetString.length))
        return result != nil
    }
}
