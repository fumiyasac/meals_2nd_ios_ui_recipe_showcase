//
//  MainTabBarController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/14.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Enum

    // MEMO: MainTabBarControllerへ配置するものに関する設定
    enum TabBarItemsType: CaseIterable {
        case curriculum
        case profile

        // 配置するタイトルを取得する
        func getTabBarTitle() -> String {
            switch self {
            case .curriculum:
                return "カリキュラム一覧"
            case .profile:
                return "プロフィール・設定"
            }
        }

        // 配置するSF Symbolsのアイコン名前を取得する
        func getTabBarSymbolName() -> String {
            switch self {
            case .curriculum:
                return "book.fill"
            case .profile:
                return "person.circle.fill"
            }
        }
    }

    // MARK: - Properties

    private let itemSize = CGSize(width: 28.0, height: 28.0)
    private let normalColor: UIColor = UIColor.lightGray
    private let selectedColor: UIColor = UIColor(code: "#ef93b6")
    private let tabBarItemFont = UIFont(name: "HelveticaNeue-Medium", size: 10)!

    // パスコードロック画面表示をするかの確認を実施する ※viewDidAppearの中で最初の1回目のみ実行されるような形にしている
    private lazy var checkPasscodeLockScreen: (() -> ())? = {
        displayPasscodeLockScreenIfNeeded()
        return nil
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainTabBarController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // パスコードロック画面の表示チェックを最初の1回目のみ実行する
        checkPasscodeLockScreen?()

        // 補足: SceneDelegate.swiftを利用しないで従来のAppDelegate.swiftのライフサイクルを利用している場合
        // アプリ起動完了時のパスコード画面表示の通知監視Observerを追加する

        // NotificationCenter.default.addObserver(self, selector: #selector(self.displayPasscodeLockScreenIfNeeded), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
    // MARK: - Private Function

    private func displayPasscodeLockScreenIfNeeded() {
        let passcodeModel = PasscodeModel()

        // パスコードロックを設定していない場合は何もしない
        if !passcodeModel.existsHashedPasscode() {
            return
        }

        // パスコードロック画面をこの画面の上にかぶせる形で表示させる
        let nav = UINavigationController(rootViewController: getPasscodeViewController())
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }

    // パスコードロック画面を取得する
    private func getPasscodeViewController() -> PasscodeViewController {
        let passcodeViewController = UIStoryboard(name: "Passcode", bundle: nil).instantiateInitialViewController() as! PasscodeViewController
        passcodeViewController.setTargetInputPasscodeType(.displayPasscodeLock)
        passcodeViewController.setTargetPresenter(nil)
        return passcodeViewController
    }

    // UITabBarControllerの初期設定に関する調整
    private func setupMainTabBarController() {

        // MEMO: UITabBarControllerDelegateの宣言
        self.delegate = self

        // MEMO: 各画面の土台となるUINavigationControllerをセットする
        let curriculumNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()

        self.viewControllers = [
            curriculumNavigationController,
            profileNavigationController
        ]
        curriculumNavigationController.pushViewController(
            UIStoryboard(name: "Curriculum", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        profileNavigationController.pushViewController(
            UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )

        // MEMO: タブの選択時・非選択時の色とアイコンのサイズを決める
        // UITabBarItem用のAttributeを決める
        let normalAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: normalColor
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: selectedColor
        ]

        let _ = TabBarItemsType.allCases.enumerated().map { (index, tabBarItem) in

            // 該当ViewControllerのタイトルの設定
            self.viewControllers?[index].title = tabBarItem.getTabBarTitle()
            // 該当ViewControllerのUITabBar要素の設定
            self.viewControllers?[index].tabBarItem.tag = index
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(normalAttributes, for: [])
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            self.viewControllers?[index].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 0.0)
            self.viewControllers?[index].tabBarItem.image
                = UIImage(
                    systemName: tabBarItem.getTabBarSymbolName(),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
                    )!.withTintColor(normalColor, renderingMode: .alwaysOriginal)
            self.viewControllers?[index].tabBarItem.selectedImage
                = UIImage(
                    systemName: tabBarItem.getTabBarSymbolName(),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
                    )!.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {}
