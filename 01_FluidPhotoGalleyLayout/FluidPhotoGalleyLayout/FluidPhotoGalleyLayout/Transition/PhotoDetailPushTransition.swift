//
//  PhotoDetailPushTransition.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/12.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: UINavigationControllerのPush遷移実行時のカスタムトランジションのクラス
// → この画面遷移クラスはGalleryNavigationControllerで適用する

final class PhotoDetailPushTransition: NSObject {

    // MARK: - Property

    // MEMO: イニシャライザの引数で引き渡される内容
    // → fromDelegate: 画面遷移元に定義したPhotoDetailTransitionAnimatorDelegateのプロトコル定義
    // → photoDetailVC: 画面遷移先となるPhotoDetailViewController
    private let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    private let photoDetailVC: PhotoDetailViewController
    
    // MEMO: 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageView
    private let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    // MARK: - Initializer

    init?(fromDelegate: Any, toPhotoDetailVC photoDetailVC: PhotoDetailViewController) {
        guard let fromDelegate = fromDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.fromDelegate = fromDelegate
        self.photoDetailVC = photoDetailVC
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PhotoDetailPushTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.24
    }

    // アニメーションの実装を定義する
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
        // MEMO: 画面遷移元と画面遷移先のView要素を追加する
        // → 遷移先はアルファ値が0の状態でContainerViewへ追加する
        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        // 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageViewを設定する
        // MEMO: スナップショットとなるUIImageViewに必要な情報は画面遷移元に定義したPhotoDetailTransitionAnimatorDelegateから取得する
        let transitionImage = fromDelegate.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = fromDelegate.imageFrame()!

        // 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageViewを追加する
        containerView.addSubview(transitionImageView)

        // 画面遷移元と画面遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移開始時の処理を実行する
        fromDelegate.transitionWillStart()
        photoDetailVC.transitionWillStart()

        // 画面遷移が完了した際のサムネイル画像の大きさを算出する
        // MEMO: 別途CGExtension.swiftに定義しているメソッドで実際の値を算出する
        let toReferenceFrame = CGRect.makeRect(aspectRatio: transitionImage.size, insideRect: toView.bounds)

        // 画面遷移時に実行するUIViewPropertyAnimatorを定義する
        // MEMO: クロージャー内に完了した時のView要素の状態を追加する
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.93) {

            // スナップショットとなるUIImageViewを遷移先に配置したUIImageViewと表示が等しくなるようにする
            self.transitionImageView.frame = toReferenceFrame

            // 遷移先の画面のアルファ値を1にする
            toView.alpha = 1
        }

        // 画面遷移アニメーションが完了した際に実行する処理を定義する
        // MEMO: クロージャー内に完了時に実施する処理を追加する
        animator.addCompletion { _ in

            // スナップショットとなるUIImageViewを画面から削除する
            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil

            // 画面遷移が完了したことを伝える
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            // 画面遷移元と画面遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移終了時の処理を実行する
            self.photoDetailVC.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()
        }

        // 画面遷移アニメーションを実行する
        animator.startAnimation()
    }
}
