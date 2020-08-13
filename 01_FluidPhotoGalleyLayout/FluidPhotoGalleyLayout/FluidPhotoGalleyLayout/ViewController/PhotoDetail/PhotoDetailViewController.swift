//
//  PhotoDetailViewController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    private let dismissPanGesture = UIPanGestureRecognizer()

    private var selectedRectanglePhoto: RectanglePhoto!

    // MEMO: PanGestureRecognizerで発動したDismiss時のアニメーション発火状況
    // → GalleryNavigationControllerで適用するアニメーションまたはInteractionをハンドリングする用途で使用する
    private(set) var isInteractivelyDismissing: Bool = false

    // MARK: - PhotoDetailInteractiveDismissTransition

    // MEMO: PanGestureRecognizerと連動したDismiss時のアニメーションに関するプロトコル
    // → PhotoDetailInteractiveDismissTransitionに定義した振る舞いを実行する
    weak var transitionController: PhotoDetailInteractiveDismissTransition? = nil

    // MARK: - @IBOutlet

    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle(selectedRectanglePhoto.title)
        setupPhotoDetailImageView()
        setupDismissPanGesture()
    }

    // MARK: - Function

    func setRectanglePhoto(rectanglePhoto: RectanglePhoto) {
        selectedRectanglePhoto = rectanglePhoto
    }

    // MARK: - Private Function

    private func setupPhotoDetailImageView() {
        imageView.image = UIImage(named: selectedRectanglePhoto.thumbnailName)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.accessibilityIgnoresInvertColors = true
    }

    private func setupDismissPanGesture() {
        self.view.addGestureRecognizer(dismissPanGesture)
        dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {

        // 画面のおおもととなるView要素に付与したPanGestureRecognizerが発火した際の振る舞いを定義する
        switch gesture.state {

        // Dismiss時のアニメーション発火状況をtrueにして遷移元へ戻る画面遷移を試みる
        case .began:
            isInteractivelyDismissing = true
            self.navigationController?.popViewController(animated: true)

        // Dismiss時のアニメーション発火状況をfalseにする
        case .cancelled, .failed, .ended:
            isInteractivelyDismissing = false

        // それ以外の場合には特に処理は実施しない
        case .changed, .possible:
            break
        default:
            break
        }

        // PhotoDetailInteractiveDismissTransitionに定義したこの画面でPanGestureRecognizerが発火した際の処理を実行する
        transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

// MARK: - PhotoDetailTransitionAnimatorDelegate

extension PhotoDetailViewController: PhotoDetailTransitionAnimatorDelegate {

    // 画面遷移処理が開始した際に実行される処理
    // → この画面に表示するUIImageViewを見えない状態にする
    func transitionWillStart() {
        imageView.isHidden = true
    }

    // 画面遷移処理が終了した際に実行される処理
    // → この画面に表示するUIImageViewを見える状態にする
    func transitionDidEnd() {
        imageView.isHidden = false
    }

    // 画面遷移実行時にサムネイル画像のスナップショットとなるUIImageViewの表示内容
    // → この画面に表示するUIImageViewのUIImageを割り当てる
    func referenceImage() -> UIImage? {
        return imageView.image
    }

    // 画面遷移実行時にサムネイル画像のスナップショットとなるUIImageViewの大きさ
    // → この画面に表示するUIImageViewのUIImageと実際の大きさの割合から算出する
    func imageFrame() -> CGRect? {
         return CGRect.makeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)
    }
}
