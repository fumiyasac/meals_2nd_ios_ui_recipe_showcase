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
        case stock
        case profile

        // 配置するタイトルを取得する
        func getTabBarTitle() -> String {
            switch self {
            case .curriculum:
                return "カリキュラム一覧"
            case .stock:
                return "気になるリスト"
            case .profile:
                return "プロフィール"
            }
        }

        // 配置するSF Symbolsのアイコン名前を取得する
        func getTabBarSymbolName() -> String {
            switch self {
            case .curriculum:
                return "book.fill"
            case .stock:
                return "folder.fill"
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

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainTabBarController()
    }

    // MARK: - Private Function

    // UITabBarControllerの初期設定に関する調整
    private func setupMainTabBarController() {

        // MEMO: UITabBarControllerDelegateの宣言
        self.delegate = self

        // MEMO: 各画面の土台となるUINavigationControllerをセットする
        let curriculumNavigationController = UINavigationController()
        let stockNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()

        self.viewControllers = [
            curriculumNavigationController,
            stockNavigationController,
            profileNavigationController
        ]
        curriculumNavigationController.pushViewController(
            UIStoryboard(name: "Curriculum", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        stockNavigationController.pushViewController(
            UIStoryboard(name: "Stock", bundle: nil).instantiateInitialViewController()!,
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
