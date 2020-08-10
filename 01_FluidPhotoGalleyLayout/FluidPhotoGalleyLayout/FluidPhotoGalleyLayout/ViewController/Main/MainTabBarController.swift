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

    public var isTabBarHidden: Bool = false

    public var shouldTabBarBeSuppressed: Bool {
        guard
            let currentLocketNavigationController = self.selectedViewController as? GalleryNavigationController
            else {
                fatalError()
        }
        return currentLocketNavigationController.shouldTabBarBeHidden
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

// via https://www.iamsim.me/hiding-the-uitabbar-of-a-uitabbarcontroller/
extension MainTabBarController {
    /**
    Show or hide the tab bar.
    */
    func setTabBar(hidden: Bool, animated: Bool = true, alongside animator: UIViewPropertyAnimator? = nil) {
        // We don't show the tab bar if the navigation state of the current tab disallows it.
        if !hidden, self.shouldTabBarBeSuppressed {
            return
        }

        guard isTabBarOffscreen != hidden else { return }
        self.isTabBarHidden = hidden

        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc = selectedViewController
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY

        /// Helper method for updating child view controller's safe area insets.
        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }

        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        if hidden, let insets = newInsets
        {
            set(childViewController: vc, additionalSafeArea: insets)
        }

        guard animated else {
            tabBar.frame = endFrame
            tabBar.isHidden = self.isTabBarHidden
            return
        }

        /// If the tab bar was previously hidden, we need to un-hide it.
        if self.tabBar.isHidden, !hidden {
            self.tabBar.isHidden = false
        }

        // Perform animation with coordination if one is given. Update safe area insets _after_ the animation is complete,
        // if we're showing the tab bar.
        weak var tabBarRef = self.tabBar
        if let animator = animator {
            animator.addAnimations {
                tabBarRef?.frame = endFrame
            }
            animator.addCompletion { (position) in
                let insets = (position == .end) ? newInsets : originalInsets
                if
                    !hidden,
                    let insets = insets
                {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
                if (position == .end) {
                    tabBarRef?.isHidden = hidden
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                tabBarRef?.frame = endFrame
            }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
                tabBarRef?.isHidden = hidden
            }
        }
    }

    /// `true` if the tab bar is currently hidden.
    fileprivate var isTabBarOffscreen: Bool {
        return !tabBar.frame.intersects(view.frame)
    }
}

public extension UIViewController {
    var galleryNavigationController: GalleryNavigationController? {
        return self.navigationController as? GalleryNavigationController
    }

    internal var mainTabBarController: MainTabBarController? {
        return self.tabBarController as? MainTabBarController
    }
}
