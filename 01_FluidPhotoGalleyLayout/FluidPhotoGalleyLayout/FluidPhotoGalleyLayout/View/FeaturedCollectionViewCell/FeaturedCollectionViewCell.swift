//
//  FeaturedCollectionViewCell.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class FeaturedCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFeaturedCollectionViewCell()
    }

    // MARK: - Function

    func setCell(_ featuredPhoto: FeaturedPhoto) {

        thumbnailImageView.image = UIImage(named: featuredPhoto.thumbnailName)
        titleLabel.text = featuredPhoto.title

        let descriptionAttributedKeys = UILabelDecorator.KeysForDecoration(
            lineSpacing: 7.0,
            font: UIFont(name: "HelveticaNeue-Bold", size: 12.0)!,
            foregroundColor: UIColor.white
        )
        descriptionLabel.attributedText = NSAttributedString(
            string: featuredPhoto.description,
            attributes: UILabelDecorator.getLabelAttributesBy(keys: descriptionAttributedKeys)
        )
    }

    func setDecoration(shouldDisplayBorder: Bool = true) {

        // UICollectionViewのcontentViewプロパティには罫線と角丸に関する設定を行う
        if shouldDisplayBorder {
            self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }

    // MARK: - Private Function

    private func setupFeaturedCollectionViewCell() {

        // UICollectionViewのcontentViewプロパティには罫線と角丸に関する設定を行う
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.backgroundColor = UIColor(code: "#eeeeee")

        // サムネイル画像を表示するUIImageViewの設定
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
    }
}
