//
//  FeaturedViewController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class FeaturedViewController: UIViewController {

    // MARK: - Properties

    // MEMO: 配置したUICollectionViewにおける下方向オフセット値を調整するための定数
    private let adjustedContentInsetBottom: CGFloat = 82.0

    // MEMO: セルごとの間隔を調整するための定数
    private let adjustedTargetItemGap: CGFloat = 188.0
    
    // バインダー型のUICollectionViewCellを開いた状態にするレイアウト属性クラス
    private let expandedFileBinderLayout = ExpandedFileBinderCollectionViewLayout()

    // バインダー型のUICollectionViewCellを閉じた状態にするレイアウト属性クラス
    private let indexFileBinderLayout = IndexFileBinderCollectionViewLayout()

    // バインダー型のUICollectionViewCellの状態ハンドリング用の変数
    private var shouldExpandCell = false

    private var featuredPhotos: [FeaturedPhoto] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("特集コンテンツ")
        setupCollectionView()
    }

    // MARK: - Private Function

    private func setupCollectionView() {

        // UICollectionViewに関する初期設定
        collectionView.bounces = false
        collectionView.registerCustomCell(FeaturedCollectionViewCell.self)
        collectionView.contentInset.bottom = adjustedContentInsetBottom
        collectionView.delegate = self
        collectionView.dataSource = self

        // UICollectionViewに付与するUICollectionViewLayoutを継承したクラスを付与する
        collectionView.setCollectionViewLayout(indexFileBinderLayout, animated: true)
        if let targetCollectionView = self.collectionView {
            indexFileBinderLayout.height = targetCollectionView.frame.size.height
            indexFileBinderLayout.targetItemGap = adjustedTargetItemGap
        }

        // UICollectionViewに表示するデータを取得してUICollectionViewに反映する
        featuredPhotos = getFeaturedPhotos()
    }

    private func getFeaturedPhotos() -> [FeaturedPhoto] {

        // JSONファイルから表示用のデータを取得する
        guard let path = Bundle.main.path(forResource: "featured", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let featuredPhotos = try? JSONDecoder().decode([FeaturedPhoto].self, from: data) else {
            fatalError()
        }
        return featuredPhotos
    }
}

// MARK: - UICollectionViewDelegate

extension FeaturedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // MEMO: 配置しているセルに対する処理を実施する場合に利用する
        let cell = collectionView.cellForItem(at: indexPath) as! FeaturedCollectionViewCell

        DispatchQueue.main.async {

            // MEMO: タップした対象のセルをデザインを切り替える
            cell.setDecoration(shouldDisplayBorder: self.shouldExpandCell)

            // MEMO: 変数shouldExpandCellの状態に応じてスクロール可否を適用し直す
            collectionView.isScrollEnabled = self.shouldExpandCell

            // MEMO: 変数shouldExpandCellの状態に応じてレイアウトを適用し直す
            let targetLayout: UICollectionViewLayout = self.shouldExpandCell ? self.indexFileBinderLayout : self.expandedFileBinderLayout
            collectionView.setCollectionViewLayout(targetLayout, animated: true)

            self.shouldExpandCell = !self.shouldExpandCell
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FeaturedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: FeaturedCollectionViewCell.self, indexPath: indexPath)
        cell.setCell(featuredPhotos[indexPath.row])
        cell.setDecoration()
        return cell
    }
}
