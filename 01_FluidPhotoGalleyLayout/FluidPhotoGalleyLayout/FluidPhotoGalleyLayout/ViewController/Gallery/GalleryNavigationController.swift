//
//  GalleryNavigationController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: カスタムトランジションが考慮されたUINavigationControllerを拡張したクラス

final class GalleryNavigationController: UINavigationController {

    // MARK: - Property

    // 画面遷移を実行する際に割り当てる画面遷移時のアニメーションを格納するための変数
    private var currentAnimationTransition: UIViewControllerAnimatedTransitioning? = nil

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

 // MARK: - UINavigationControllerDelegate

extension GalleryNavigationController: UINavigationControllerDelegate {

    // MEMO: UINavigationControllerのNavigationスタックに追加または削除する際（Push or Pop）の画面切り替え時に適用するアニメーションを定義する
    // → ここではインタラクティブなアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）を含まないアニメーションクラスの適用に関する設定をする
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var result: UIViewControllerAnimatedTransitioning? = nil

        // 画面遷移の種類によって適用するカスタムトランジションが異なる
        switch operation {
        case .push:

            // MEMO: Pushでの画面遷移時にはPhotoDetailPushTransitionを適用する
            if let photoDetailVC = toVC as? PhotoDetailViewController {
                result = PhotoDetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
            }

        case .pop:

            // Popでの画面遷移時には、インタラクティブなアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）が発火可否によって適用するアニメーションが異なる
            if let photoDetailVC = fromVC as? PhotoDetailViewController {

                // MEMO: Pushでの画面遷移時には、PhotoDetailViewControllerに定義したPanGestureRecognizerで発動したDismiss時のアニメーション発火状況に応じて変化する
                // → PanGestureRecognizerで発動したDismiss時のアニメーション発火状況がtrue: PhotoDetailInteractiveDismissTransition
                // → PanGestureRecognizerで発動したDismiss時のアニメーション発火状況がtrue: PhotoDetailPopTransition
                if photoDetailVC.isInteractivelyDismissing {
                    result = PhotoDetailInteractiveDismissTransition(fromDelegate: photoDetailVC, toDelegate: toVC)
                } else {
                    result = PhotoDetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
                }
            }

        default:
            break
        }

        currentAnimationTransition = result
        return result
    }

    // MEMO: UINavigationControllerのNavigationスタックに追加または削除する際（Push or Pop）の画面切り替え時に適用するアニメーションを定義する
    // → ここではインタラクティブなアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）を含むアニメーションクラスの適用に関する設定をする
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return currentAnimationTransition as? UIViewControllerInteractiveTransitioning
    }

    // MEMO: UINavigationControllerを伴う画面遷移が完了したタイミングで実行される処理
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentAnimationTransition = nil
    }
}

