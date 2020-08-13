//
//  PhotoDetailPopTransition.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/12.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDetailPopTransition: NSObject {

    // MARK: - Property

    // MEMO: イニシャライザの引数で引き渡される内容
    // → fromDelegate: 画面遷移元に定義したPhotoDetailTransitionAnimatorDelegateのプロトコル定義
    // → photoDetailVC: 画面遷移先となるPhotoDetailViewController
    private let toDelegate: PhotoDetailTransitionAnimatorDelegate
    private let photoDetailVC: PhotoDetailViewController

    // MEMO: 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageView
    private let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    // MARK: - Initializer

    init?(toDelegate: Any, fromPhotoDetailVC photoDetailVC: PhotoDetailViewController) {
        guard let toDelegate = toDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.toDelegate = toDelegate
        self.photoDetailVC = photoDetailVC
    }

    // MARK: - Static Function

    // 画面遷移アニメーションに必要なダミーのframe値を算出する
    // MEMO: 拡大画像表示をする画面(PhotoDetailViewController)を元に算出した値
    static func defaultOffscreenFrameForDismissal(transitionImageSize: CGSize, screenHeight: CGFloat) -> CGRect {
        return CGRect(x: 0, y: screenHeight, width: transitionImageSize.width, height: transitionImageSize.height)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PhotoDetailPopTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.24
    }

    // 画面遷移コンテキスト(UIViewControllerContextTransitioning)を利用する
    // → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // コンテキストを元に遷移先と遷移元のViewインスタンスを取得する
        // MEMO: 取得できなかった場合は以降の処理を実施しない
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // アニメーションの実体となるContainerViewに必要なものを追加する
        // MEMO: 遷移元と遷移先のView要素を追加する
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        // 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageViewを設定する
        // MEMO: スナップショットとなるUIImageViewに必要な情報は画面遷移元に定義したPhotoDetailTransitionAnimatorDelegateから取得する
        let transitionImage = photoDetailVC.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = photoDetailVC.imageFrame()!

        // 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageViewを追加する
        containerView.addSubview(transitionImageView)

        // 遷移元と遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移開始時の処理を実行する
        photoDetailVC.transitionWillStart()
        toDelegate.transitionWillStart()

        // 拡大画像表示をする画面(PhotoDetailViewController)に配置したサムネイル画像のframe値を算出する
        let fromReferenceFrame = photoDetailVC.imageFrame()!

        // 画面遷移時に実行するUIViewPropertyAnimatorを定義する
        // MEMO: クロージャー内に完了した時のView要素の状態を追加する
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.93) {
            fromView.alpha = 0
        }

        // 画面遷移アニメーションが完了した際に実行する処理を定義する
        // MEMO: クロージャー内に完了時に実施する処理を追加する
        animator.addCompletion { _ in

            // スナップショットとなるUIImageViewを画面から削除する
            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil

            // 画面遷移が完了したことを伝える
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            // 遷移元と遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移終了時の処理を実行する
            self.toDelegate.transitionDidEnd()
            self.photoDetailVC.transitionDidEnd()
        }

        // 画面遷移アニメーションを実行する
        animator.startAnimation()

        // 遷移元のレイアウト状態とのつじつま合わせのために実施する処理
        // MEMO: 少し遅延を持たせてスナップショットとなるUIImageViewの大きさを反映させることでUICollectionViewのレイアウトを更新するために実施している
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            animator.addAnimations {

                // MEMO: 遷移元でアニメーションに関わるUIImageView情報を取得を試みる
                if let toReferenceFrame = self.toDelegate.imageFrame() {

                    // MEMO: 拡大画像表示をする画面(PhotoDetailViewController)に配置したサムネイル画像のframe値を適用する
                    self.transitionImageView.frame = toReferenceFrame

                } else {

                    // MEMO: 画面遷移アニメーションに必要なダミーのframe値を適用する
                    self.transitionImageView.frame = PhotoDetailPopTransition.defaultOffscreenFrameForDismissal(
                        transitionImageSize: fromReferenceFrame.size,
                        screenHeight: containerView.bounds.height
                    )
                }
            }
        }
    }
}
