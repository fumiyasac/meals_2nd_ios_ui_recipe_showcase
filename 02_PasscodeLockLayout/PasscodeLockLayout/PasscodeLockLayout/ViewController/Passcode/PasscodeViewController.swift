//
//  PasscodeViewController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/16.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class PasscodeViewController: UIViewController {

    // MARK: - Property

    private var inputPasscodeType: InputPasscodeType!
    private var presenter: PasscodePresenter!
    private var userInputPasscode: String = ""

    // MEMO: パスコードが一致しない場合及び一致する場合における軽微な振動を追加する
    private let notificationFeedbackGenerator: UINotificationFeedbackGenerator = {
        let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()
    
    // MARK: - @IBOutlet

    @IBOutlet weak private var inputPasscodeMessageLabel: UILabel!
    @IBOutlet weak private var inputPasscodeDisplayView: InputPasscodeDisplayView!
    @IBOutlet weak private var inputPasscodeKeyboardView: InputPasscodeKeyboardView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle(inputPasscodeType.getTitle())
        removeBackButtonText()
        setupInputPasscodeMessageLabel()
        setupPasscodeNumberKeyboardView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideTabBarItems()
    }

    // MARK: - Function

    // Presenter初期化前にこの画面をどの用途で利用するか決定する値(Enum値)をセットする
    func setTargetInputPasscodeType(_ inputPasscodeType: InputPasscodeType) {
        self.inputPasscodeType = inputPasscodeType
    }

    // 画面遷移元でPresenterを初期化するために利用する
    func setTargetPresenter(_ previousPasscode: String?) {
        self.presenter = PasscodePresenter(presenter: self, previousPasscode: previousPasscode)
    }

    // MARK: - Private Function

    // この画面に配置したテキスト表示ラベルに関する初期設定をする
    private func setupInputPasscodeMessageLabel() {
        inputPasscodeMessageLabel.text = inputPasscodeType.getMessage()
    }

    // この画面に配置したテンキー状のViewに関する初期設定をする
    private func setupPasscodeNumberKeyboardView() {
        inputPasscodeKeyboardView.delegate = self

        // MEMO: 利用している端末のFaceIDやTouchIDの状況やどの画面で利用しているか見てボタン状態を判断する
        var isEnabledLocalAuthenticationButton: Bool = false
        if inputPasscodeType == .displayPasscodeLock {
            isEnabledLocalAuthenticationButton = LocalAuthenticationManager.getDeviceOwnerLocalAuthenticationType() != .authWithManual
        }
        inputPasscodeKeyboardView.shouldEnabledLocalAuthenticationButton(isEnabledLocalAuthenticationButton)
    }

    private func hideTabBarItems() {
        if let tabBarVC = self.tabBarController {
            tabBarVC.tabBar.isHidden = true
        }
    }

    // 画面での入力イベントを許可する
    private func acceptUserInteraction() {
        self.view.isUserInteractionEnabled = true
    }

    // 画面での入力イベントを拒否する
    private func refuseUserInteraction() {
        self.view.isUserInteractionEnabled = false
    }

    // 最初の処理Aを実行 → 指定秒数後に次の処理Bを実行するためのラッパー
    // MEMO: 早すぎる入力を行なった際に意図しない画面遷移を実行される現象の対応策として実行している
    private func executeSeriesAction(firstAction: (() -> ())? = nil, deleyedAction: @escaping (() -> ())) {
        // 最初は該当画面のUserInteractionを受け付けない
        self.refuseUserInteraction()
        firstAction?()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            // 指定秒数経過後は該当画面のUserInteractionを受け付ける
            self.acceptUserInteraction()
            deleyedAction()
        }
    }
}

// MARK: - PasscodeNumberKeyboardDelegate

extension PasscodeViewController: InputPasscodeKeyboardDelegate {

    // テンキー状のViewで0から9の数値ボタンが押下された際に実行される処理
    func inputPasscodeNumber(_ numberOfString: String) {

        // パスコードが0から3文字の場合は押下された数値の文字列を末尾に追加する
        if 0...3 ~= userInputPasscode.count {
            userInputPasscode = userInputPasscode + numberOfString
            inputPasscodeDisplayView.incrementDisplayImagesBy(passcodeStringCount: userInputPasscode.count)
        }

        // パスコードが4文字の場合はPasscodePresenter側に定義した入力完了処理を実行する
        if userInputPasscode.count == 4 {
            presenter.inputCompleted(userInputPasscode, inputPasscodeType: inputPasscodeType)
        }
    }

    // テンキー状のViewで削除ボタンが入力が押下された際に実行される処理
    func deletePasscodeNumber() {

        // パスコードが1から3文字の場合は数値の文字列の末尾を削除する
        if 1...3 ~= userInputPasscode.count {
            userInputPasscode = String(userInputPasscode.prefix(userInputPasscode.count - 1))
            inputPasscodeDisplayView.decrementDisplayImagesBy(passcodeStringCount: userInputPasscode.count)
        }
    }

    // テンキー状のViewでTouchIDまたはFaceIDでの生体認証を実行するボタンが押下された際に実行される処理
    func executeLocalAuthentication() {

        // パスコードロック画面以外では操作を許可しない
        guard inputPasscodeType == .displayPasscodeLock else {
            return
        }

        // TouchID/FaceIDによる認証を実行し、成功した場合にはパスコードロックを解除する
        LocalAuthenticationManager.evaluateDeviceOwnerLocalAuthentication(
            successHandler: {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            },
            errorHandler: {}
        )
    }
}

// MARK: - PasscodePresenterProtocol

extension PasscodeViewController: PasscodePresenterProtocol {

    // 次に表示するべき画面へ入力された値を引き継いだ状態で遷移する
    func goNext() {
        executeSeriesAction(
            firstAction: {},
            deleyedAction: {
                // Enum経由で次のアクションで設定すべきEnumの値を取得する
                guard let nextInputPasscodeType = self.inputPasscodeType.getNextInputPasscodeType() else {
                    return
                }
                // 遷移先のViewControllerに関する設定をする
                let passcodeViewController = UIStoryboard(name: "Passcode", bundle: nil).instantiateInitialViewController() as! PasscodeViewController
                passcodeViewController.setTargetInputPasscodeType(nextInputPasscodeType)
                passcodeViewController.setTargetPresenter(self.userInputPasscode)
                self.navigationController?.pushViewController(passcodeViewController, animated: true)

                self.userInputPasscode.removeAll()
                self.inputPasscodeDisplayView.decrementDisplayImagesBy()
            }
        )
    }

    // パスコードロック画面を解除する
    func dismissPasscodeLock() {
        executeSeriesAction(
            // Success時のHaptic Feedbackのを実行する
            firstAction: {
                self.notificationFeedbackGenerator.notificationOccurred(.success)
            },
            deleyedAction: {
                self.dismiss(animated: true, completion: nil)
            }
        )
    }

    // ユーザーが入力したパスコードを保存して設定画面へ戻る
    func savePasscode() {
        executeSeriesAction(
            firstAction: {},
            deleyedAction: {
                self.navigationController?.popToRootViewController(animated: true)
            }
        )
    }

    // ユーザーが入力した値が正しくないことをユーザーへ伝える
    func showError() {
        executeSeriesAction(
            // 実行直後はエラーメッセージを表示する & Error時のHaptic Feedbackのを実行する
            firstAction: {
                self.inputPasscodeMessageLabel.text = "パスコードが一致しませんでした"
                self.notificationFeedbackGenerator.notificationOccurred(.error)
            },
            // 秒数経過後にユーザーが入力したメッセージを空にする & パスコードのハート表示をリセットする
            deleyedAction: {
                self.userInputPasscode.removeAll()
                self.inputPasscodeDisplayView.decrementDisplayImagesBy()
            }
        )
    }
}
