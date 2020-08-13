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
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground: バックグラウンドからフォアグラウンドへ移行しようとした時")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground: バックグラウンドへ移行完了した時")
    }
}
