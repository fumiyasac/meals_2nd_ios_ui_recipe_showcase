//
//  PhotoDetailTransitionAnimatorDelegate.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: サムネイル写真が浮き上がってくるような表現をするカスタムトランジションを実現するために必要な画面遷移元及び画面遷移先の情報を取得するためのプロトコル定義
// 参考: 実装の参考にした記事とリポジトリ
// https://devsign.co/notes/navigation-transitions-iv
// https://github.com/bryanjclark/devsign-nav-transitions

// MARK: - Protocol

protocol PhotoDetailTransitionAnimatorDelegate: class {

    // 画面遷移処理が開始した際に実行される処理
    // MEMO: 遷移先から前の画面へ戻る時のみPhotoDetailInteractiveDismissTransitionで途中で中断することも考慮している
    func transitionWillStart()

    // 画面遷移処理が終了した際に実行される処理
    func transitionDidEnd()

    // 画面遷移実行時にサムネイル画像のスナップシャットとなるUIImageViewの表示内容
    func referenceImage() -> UIImage?

    // 画面遷移実行時にサムネイル画像のスナップシャットとなるUIImageViewの大きさ
    func imageFrame() -> CGRect?
}
