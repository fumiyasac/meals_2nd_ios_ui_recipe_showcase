//
//  PhotoDetailInteractiveDismissTransition.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: インタラクティブな制御を伴うアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）の実装クラス

// 参考: 画面遷移を伴うアニメーションを構成する際に必要な処理の理解に関してはこの資料での解説がわかりやすかったです。
// https://speakerdeck.com/shunkitan/hong-rixin-di-falseliang-i-interactive-transitionwomasutasiyou-iosdc-2017

final class PhotoDetailInteractiveDismissTransition: NSObject {

    // MARK: - Property

    // MEMO: イニシャライザの引数で引き渡される内容
    // → fromDelegate: 画面遷移元に定義したPhotoDetailTransitionAnimatorDelegateのプロトコル定義
    // → toDelegate: 画面遷移先に定義したPhotoDetailTransitionAnimatorDelegateのプロトコル定義
    private let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    private weak var toDelegate: PhotoDetailTransitionAnimatorDelegate?

    // 画面遷移元または画面遷移先のUIImageViewの大きさを格納する変数
    private var fromReferenceImageViewFrame: CGRect? = nil
    private var toReferenceImageViewFrame: CGRect? = nil

    // MEMO: 画面遷移時の画面背景アニメーションの内容を格納する変数
    private var currentBackgroundAnimation: UIViewPropertyAnimator? = nil
    
    // MEMO: 画面遷移時に渡されるコンテキスト情報を格納する変数
    private var currentTransitionContext: UIViewControllerContextTransitioning? = nil

    // MEMO: 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageView
    private let currentTransitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    // MARK: - Initializer

    init(fromDelegate: PhotoDetailViewController, toDelegate: Any) {
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate as? PhotoDetailTransitionAnimatorDelegate

        super.init()
    }

    // MARK: - Function
    
    // PhotoDetailViewController側で実行されたUIPanGestureRecognizerと連動した処理を実行する
    // MEMO: このサンプルではY軸方向における下方向へのDragして指を離した時の変化量に応じて前の画面に戻るアニメーションを実行させる（上方向へDragして指を離した時は元の位置に戻るだけ）
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {

        // コンテキスト情報とサムネイル画像スナップショットを利用する
        // MEMO: このタイミングではstartInteractiveTransitionも一緒実行されている点がポイント
        let transitionContext = currentTransitionContext!
        let transitionImageView = currentTransitionImageView

        // UIPanGestureRecognizerで返ってくるY軸方向の変化量を取得する
        let translation = gestureRecognizer.translation(in: nil)
        let translationVertical = translation.y
        
        // 画面遷移の完了割合とそれに応じたサムネイル画像スナップショットの拡大縮小割合を算出する
        let percentageComplete = getPercentageComplete(forVerticalDrag: translationVertical)
        let transitionImageScale = getTransitionImageScaleFor(percentageComplete: percentageComplete)

        // 引数で渡されたPanGestureRecognizerの状態に応じた画面遷移の状態を反映する
        switch gestureRecognizer.state {

        // MEMO: 何らかの理由でキャンセルまたは失敗した場合はアニメーションを完了させる
        case .cancelled, .failed:

            completeTransition(didCancel: true)

        // 指を動かしている状態の場合は現在位置に応じた画面遷移の完了割合を適用する
        case .changed:

            transitionImageView.transform = CGAffineTransform.identity
                .scaledBy(x: transitionImageScale, y: transitionImageScale)
                .translatedBy(x: translation.x, y: translation.y)
            transitionContext.updateInteractiveTransition(percentageComplete)
            currentBackgroundAnimation?.fractionComplete = percentageComplete

        // 指が離れた場合はその時の位置関係を基準にした画面遷移の完了割合に応じた画面遷移処理の振る舞いを決定する
        case .ended:

            // MEMO: 画面遷移の完了割合に応じて画面遷移を完了させるかを決定する
            let fingerIsMovingDownwards = gestureRecognizer.velocity(in: nil).y > 0
            let transitionMadeSignificantProgress = percentageComplete > 0.1
            let shouldComplete = fingerIsMovingDownwards && transitionMadeSignificantProgress
            completeTransition(didCancel: !shouldComplete)

        default:
            break
        }
    }

    // MARK: - Private Function

    // 画面遷移アニメーションを完了させるための処理（引数に渡しているのはキャンセルするか否かのフラグ値）
    private func completeTransition(didCancel: Bool) {

        // MEMO: 画面遷移アニメーションがキャンセルされた場合は逆のアニメーションを適用するかを決める
        currentBackgroundAnimation?.isReversed = didCancel ? true : false

        // コンテキスト情報と画面遷移時の画面背景アニメーションの内容を利用する
        let transitionContext = currentTransitionContext!
        let backgroundAnimation = currentBackgroundAnimation!

        // UIViewPropertyAnimatorのcompletionDuration＆dampingRatioの設定
        let completionDuration: Double = didCancel ? 0.46 : 0.36
        let completionDamping: CGFloat = didCancel ? 0.75 : 0.90

        // 画面遷移時のサムネイル画像が動くアニメーションを実行するUIViewPropertyAnimatorを定義する
        // MEMO: クロージャー内に完了した時のView要素の状態を追加する
        let foregroundAnimation = UIViewPropertyAnimator(duration: completionDuration, dampingRatio: completionDamping) {

            // サムネイル画像スナップショットの拡大縮小割合を元に戻してリセットする
            self.currentTransitionImageView.transform = CGAffineTransform.identity
            
            // サムネイル画像スナップショットの大きさを適用する
            // MEMO: 画面遷移を完了する場合は画面遷移先の情報を元にしている
            if didCancel {
                self.currentTransitionImageView.frame = self.fromReferenceImageViewFrame!
            } else {
                self.currentTransitionImageView.frame = self.toDelegate?.imageFrame() ?? self.toReferenceImageViewFrame!
            }
        }

        // 画面遷移アニメーションが完了した際に実行する処理を定義する
        // MEMO: クロージャー内に完了時に実施する処理を追加する
        foregroundAnimation.addCompletion { [weak self] (position) in

            // MEMO: 循環参照を防ぐために弱参照にしている
            guard let weakSelf = self else {
                return
            }

            // スナップショットとなるUIImageViewを画面から削除する
            weakSelf.currentTransitionImageView.removeFromSuperview()
            weakSelf.currentTransitionImageView.image = nil

            // 画面遷移元と画面遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移終了時の処理を実行する
            weakSelf.toDelegate?.transitionDidEnd()
            weakSelf.fromDelegate.transitionDidEnd()

            // 引数に渡しているのはキャンセルするか否かのフラグ値に応じて画面遷移をキャンセルするか完了するかを決める
            if didCancel {
                transitionContext.cancelInteractiveTransition()
            } else {
                transitionContext.finishInteractiveTransition()
            }

            // 画面遷移が完了またはキャンセルしたかを伝える
            transitionContext.completeTransition(!didCancel)

            // 画面遷移時に渡されるコンテキスト情報を空にする
            weakSelf.currentTransitionContext = nil
        }

        // 画面遷移時の画面背景アニメーションを実行する
        let durationFactor = CGFloat(foregroundAnimation.duration / backgroundAnimation.duration)
        backgroundAnimation.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)

        // 画面遷移時のサムネイル画像が動くアニメーションを実行する
        foregroundAnimation.startAnimation()
    }

    // PhotoDetailViewControllerに配置したUIImageViewのドラッグ位置に基づいた画面遷移の完了割合を算出する
    // 現在の設定は下記の通り（100%となった場合には画面遷移が実行された状態と等しい）
    // 例. Y軸方向の位置の値と割合
    // (1) -100px動いた -> 0%
    // (2) 動いていない -> 0%
    // (3) 20px動いた -> 10%
    // (4) 200px動いた -> 100%
    // (5) 400px動いた -> 100%
    private func getPercentageComplete(forVerticalDrag verticalDrag: CGFloat) -> CGFloat {
        let maximumDelta = CGFloat(200)
        return CGFloat.scaleAndShift(value: verticalDrag, inRange: (min: CGFloat(0), max: maximumDelta))
    }

    // 画面遷移の完了割合に応じたサムネイル画像スナップショットの拡大縮小割合を算出する
    private func getTransitionImageScaleFor(percentageComplete: CGFloat) -> CGFloat {
        let minScale = CGFloat(0.68)
        let result = 1 - (1 - minScale) * percentageComplete
        return result
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PhotoDetailInteractiveDismissTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.24
    }

    // 画面遷移コンテキスト(UIViewControllerContextTransitioning)を利用する
    // → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // MEMO: ここではインタラクティブな制御を伴うアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）を適用したいのでここは実装しない
        // → 画面遷移が実行に関連する実装はUIViewControllerInteractiveTransitioningのextension側に定義する
        assertionFailure("今回の処理ではこの処理が実行されることはない想定です。")
    }
}

// MARK: - UIViewControllerInteractiveTransitioning

extension PhotoDetailInteractiveDismissTransition: UIViewControllerInteractiveTransitioning {

    // インタラクティブな制御を伴うアニメーション（ここではUIPanGestureRecognizerを伴って画面の状態が変化しうるアニメーション）が開始されたタイミングで実行される処理
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {

        // 画面遷移時に渡されるコンテキスト情報を変数に持たせる
        currentTransitionContext = transitionContext

        // コンテキストを元に遷移先と遷移元のView等必要なインスタンスを取得する
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromImageFrame = fromDelegate.imageFrame(),
            let fromImage = fromDelegate.referenceImage(),
            let fromVC = transitionContext.viewController(forKey: .from) as? PhotoDetailViewController
        else {
            return
        }

        // PhotoDetailViewControllerに定義したPanGestureRecognizerと連動したDismiss時のアニメーションに関するプロトコルを適用する
        fromVC.transitionController = self

        // 画面遷移元と画面遷移先に定義したPhotoDetailTransitionAnimatorDelegateの画面遷移開始時の処理を実行する
        fromDelegate.transitionWillStart()
        toDelegate?.transitionWillStart()

        // 画面遷移元と画面遷移先の画面遷移時の表現に関わるUIImageViewの大きさを取得する
        fromReferenceImageViewFrame = fromImageFrame
        // MEMO: PhotoDetailPopTransitionの内容から値を取得する（画面遷移アニメーションに必要なダミーのframe値を算出するメソッドを定義している）
        toReferenceImageViewFrame = PhotoDetailPopTransition.defaultOffscreenFrameForDismissal(
            transitionImageSize: fromImageFrame.size,
            screenHeight: fromView.bounds.height
        )

        // アニメーションの実体となるContainerViewに必要なものを追加する
        // MEMO: 画面遷移元と画面遷移先のView要素を追加する
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(currentTransitionImageView)

        // 画面遷移時にサムネイル画像が動くアニメーションを実現するためのスナップショットとなるUIImageViewを設定する
        currentTransitionImageView.image = fromImage
        currentTransitionImageView.frame = fromImageFrame

        // 画面遷移時に実行するUIViewPropertyAnimatorを定義する
        // MEMO: クロージャー内に完了した時のView要素の状態を追加する
        let animation = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {

            if let _ = self.toDelegate {
                fromView.alpha = 0
            } else {
                // MEMO: この場合は画面遷移元と画面遷移先の画面遷移に関する設定が正しくない状態
                assertionFailure("self.toDelegateがnilなので定義されていません")
            }
        })

        // 画面遷移時の画面背景アニメーション情報を変数に格納する
        currentBackgroundAnimation = animation
    }
}
