//
//  SceneDelegate.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

// MEMO: SceneDelegateを利用していないアプリの場合のAppDelegateへの対応は下記のような形になります。
// (1) applicationWillResignActive: フォアグラウンドからバックグラウンドへ移行しようとした時
// (2) applicationDidEnterBackground: バックグラウンドへ移行完了した時
// (3) applicationWillEnterForeground: バックグラウンドからフォアグラウンドへ移行しようとした時
// (4) applicationDidBecomeActive: アプリの状態がアクティブになった時
// (5) applicationWillTerminate: アプリ終了時"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect: アプリ終了時")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneWillEnterForeground: アプリの状態がアクティブになった時")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive: フォアグラウンドからバックグラウンドへ移行しようとした時")

        // パスコードロック画面を表示する
        // MEMO: こちらのサンプルでは起動時にパスコードロックはかけない様にしています。
        // 注意点: 他に実装されている処理の関係でsceneWillResignActiveだとうまくいかない場合は、sceneDidEnterBackgroundに当該処理を移行しても良いかと思います。
        displayPasscodeLockScreenIfNeeded()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground: バックグラウンドからフォアグラウンドへ移行しようとした時")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground: バックグラウンドへ移行完了した時")
    }

    // MARK: - Private Function

    private func displayPasscodeLockScreenIfNeeded() {
        let passcodeModel = PasscodeModel()

        // パスコードロックを設定していない場合は何もしない
        if !passcodeModel.existsHashedPasscode() {
            return
        }

        if let rootViewController = getCurrentDisplayWindow()?.rootViewController {

            // 現在のrootViewControllerにおいて一番上に表示されているViewControllerを取得する
            var topViewController: UIViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }

            // すでにパスコードロック画面がかぶせてあるかを確認する
            let isDisplayedPasscodeLock: Bool = topViewController.children.map { viewController in
                return viewController is PasscodeViewController
            }.contains(true)

            // パスコードロック画面がかぶせてなければかぶせる
            if !isDisplayedPasscodeLock {
                let nav = UINavigationController(rootViewController: getPasscodeViewController())
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                topViewController.present(nav, animated: true, completion: nil)
            }
        } else {
            assertionFailure("rootViewControllerの取得に失敗しています。")
        }
    }

    private func getPasscodeViewController() -> PasscodeViewController {
        let passcodeViewController = UIStoryboard(name: "Passcode", bundle: nil).instantiateInitialViewController() as! PasscodeViewController
        passcodeViewController.setTargetInputPasscodeType(.displayPasscodeLock)
        passcodeViewController.setTargetPresenter(nil)
        return passcodeViewController
    }

    // rootViewControllerを探索して取得する
    private func getCurrentDisplayWindow() -> UIWindow? {

        // 現在表示されているUIWindowインスタンスを取得する（※iOS13以降とそれ以下では取得方法が異なる点に注意！）
        if #available(iOS 13.0, *) {
            return  UIApplication.shared.connectedScenes
                .map{ $0 as? UIWindowScene }
                .compactMap{ $0 }
                .first?.windows
                .filter{ $0.isKeyWindow }
                .first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
