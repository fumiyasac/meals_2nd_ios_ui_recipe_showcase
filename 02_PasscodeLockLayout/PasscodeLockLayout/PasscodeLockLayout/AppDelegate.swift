//
//  AppDelegate.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("didFinishLaunchingWithOptions: アプリ起動時")

        // MEMO: iOS15に関する配色に関する調整対応
        setupNavigationBarAppearance()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    // MARK: - Private Function

    private func setupNavigationBarAppearance() {

        // iOS15以降ではUINavigationBarの配色指定方法が変化する点に注意する
        // https://shtnkgm.com/blog/2021-08-18-ios15.html
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()

            // MEMO: UINavigationBar内部におけるタイトル文字の装飾設定
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14.0)!,
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]

            // MEMO: UINavigationBar背景色の装飾設定
            navigationBarAppearance.backgroundColor = UIColor(code: "#ef93b6")

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}
