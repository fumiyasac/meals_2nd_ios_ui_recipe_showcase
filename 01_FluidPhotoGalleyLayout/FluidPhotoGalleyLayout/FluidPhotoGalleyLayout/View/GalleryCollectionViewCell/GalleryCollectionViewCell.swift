//
//  GalleryCollectionViewCell.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

// MEMO: AutoLayoutの制約に関しての対処
// UICollectionViewのレイアウト属性クラスを独自にカスタマイズをする場合にはレイアウトの警告には注意する必要がある。
// 特に今回のセル表示に関しては縦:200px × 横:200pxのAutoLayoutの制約がセルいっぱいに配置している要素に必要だった。 → つまりは最低サイズを決める制約が決まっていないために発生していた。
// → 「The behavior of the UICollectionViewFlowLayout is not defined because: the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values.」 ... のような警告ログが表示される。
// 参考: https://qiita.com/usagimaru/items/e0a4c449d4cdf341e152

final class GalleryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let cellSize: CGSize = CGSize(width: 200.0, height: 200.0)

    // MARK: - @IBOutlet

    @IBOutlet private(set) weak var thumbnailImageView: UIImageView!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGalleryCollectionViewCell()
    }

    // MARK: - Function

    func setCell(_ rectanglePhoto: RectanglePhoto) {

        thumbnailImageView.image = UIImage(named: rectanglePhoto.thumbnailName)
    }

    // MARK: - Private Function

    private func setupGalleryCollectionViewCell() {
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
    }
}
