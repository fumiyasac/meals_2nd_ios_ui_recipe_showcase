//
//  PasscodePresenter.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/16.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol PasscodePresenterProtocol: class {
    func goNext()
    func dismissPasscodeLock()
    func savePasscode()
    func showError()
}

final class PasscodePresenter {

    // MARK: - Property

    private (set)var presenter: PasscodePresenterProtocol!

    private let previousPasscode: String?

    // MARK: - Initializer

    // MEMO: 前の画面で入力したパスコードを利用したい場合は引数に設定する
    init(presenter: PasscodePresenterProtocol, previousPasscode: String?) {
        self.presenter = presenter
        self.previousPasscode = previousPasscode
    }

    // MARK: - Function

    // ViewController側でパスコードの入力が完了した場合に実行する処理
    func inputCompleted(_ passcode: String, inputPasscodeType: InputPasscodeType) {
        let passcodeModel = PasscodeModel()

        switch inputPasscodeType {
        
        case .inputForCreate, .inputForUpdate:

            // 再度パスコードを入力するための確認画面へ遷移する
            presenter.goNext()
            break


        case .retryForCreate, .retryForUpdate:

            // 前画面で入力したパスコードと突き合わせて、同じだったらUserDefaultへ登録する
            if previousPasscode != passcode {
                presenter.showError()
                return
            }
            if passcodeModel.saveHashedPasscode(passcode) {
                presenter.savePasscode()
            } else {
                presenter.showError()
            }
            break


        case .displayPasscodeLock:

            // 保存されているユーザーが設定したパスコードと突き合わせて、同じだったらパスコードロック画面を解除する
            if passcodeModel.compareSavedPasscodeWith(inputPasscode: passcode) {
                presenter.dismissPasscodeLock()
            } else {
                presenter.showError()
            }
            break
        }
    }
}

