//
//  MainTabBarController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Enum

    // MEMO: MainTabBarControllerへ配置するものに関する設定
    private enum TabBarItemsType: CaseIterable {

        case gallery
        case featured

        // MARK: - Function

        // 配置するタイトルを取得する
        func getTabBarTitle() -> String {
            switch self {
            case .gallery:
                return "Photo Gallery"
            case .featured:
                return "Featured Contents"
            }
        }

        // 配置するSF Symbolsのアイコン名前を取得する
        func getTabBarSymbolName() -> String {
            switch self {
            case .gallery:
                return "photo.fill.on.rectangle.fill"
            case .featured:
                return "rectangle.stack.fill"
            }
        }
    }

    // MARK: - Properties

    private let itemSize = CGSize(width: 28.0, height: 28.0)
    private let normalColor: UIColor = UIColor.lightGray
    private let selectedColor: UIColor = UIColor.systemYellow
    private let tabBarItemFont = UIFont(name: "HelveticaNeue-Medium", size: 10)!

    // MEMO: UITabBarの切り替え時に実行するカスタムトランジションのクラス
    private let tabBarTransition = MainTabBarTransition()

    // TabBar部分を押下した際に発火するアニメーション(CoreAnimation)
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainTabBarController()
    }

    // UITabBarItemが押下された際に実行される処理
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        // MEMO: UITabBarに配置されているUIImageView要素に対してアニメーションさせるための処理
        // (参考) https://bit.ly/2VCP5Am
        guard let index = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > index + 1,
            let imageView = tabBar.subviews[index + 1].subviews[1] as? UIImageView else {
            return
        }
        // MEMO: 抽出したUIImageView要素に対してCoreAnimationを適用する
        imageView.layer.add(bounceAnimation, forKey: nil)
    }

    // MARK: - Private Function

    // UITabBarControllerの初期設定に関する調整
    private func setupMainTabBarController() {

        // MEMO: UITabBarControllerDelegateの宣言
        self.delegate = self
        
        // MEMO: 各画面の土台となるUINavigationControllerをセットする
        let galleryNavigationController = GalleryNavigationController()
        let featuredNavigationController = UINavigationController()

        self.viewControllers = [
            galleryNavigationController,
            featuredNavigationController
        ]
        galleryNavigationController.pushViewController(
            UIStoryboard(name: "Gallery", bundle: nil).instantiateInitialViewController()!,
            animated: false
        )
        featuredNavigationController.pushViewController(
            UIStoryboard(name: "Featured", bundle: nil).instantiateInitialViewController()!,
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

extension MainTabBarController: UITabBarControllerDelegate {

    // UITabBarControllerの画面遷移が実行された場合の遷移アニメーションの定義
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return tabBarTransition
    }
}
