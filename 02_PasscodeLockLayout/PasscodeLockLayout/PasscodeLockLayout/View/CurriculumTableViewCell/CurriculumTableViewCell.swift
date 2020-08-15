//
//  CurriculumTableViewCell.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol CurriculumTableViewCellToggleDelegate: NSObjectProtocol {
    func showCourseButtonTappedHandler(curriculum: CurriculumModel?)
}

final class CurriculumTableViewCell: UITableViewCell {

    // MARK: - Property

    weak var delegate: CurriculumTableViewCellToggleDelegate?

    private var curriculum: CurriculumModel? = nil

    // MARK: - @IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var catchCopyLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var teacherNameLabel: UILabel!
    @IBOutlet private weak var introductionLabel: UILabel!
    @IBOutlet private weak var termAndCourseCountLabel: UILabel!
    @IBOutlet private weak var showCourseButton: UIButton!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCurriculumTableViewCell()
    }

    // MARK: - Function

    func setCell(_ curriculum: CurriculumModel) {

        self.curriculum = curriculum

        let titleAttributedKeys = UILabelDecorator.KeysForDecoration(
            lineSpacing: 6.0,
            font: UIFont(name: "HelveticaNeue-Bold", size: 15.0)!,
            foregroundColor: UIColor.white
        )
        titleLabel.attributedText = NSAttributedString(
            string: curriculum.title,
            attributes: UILabelDecorator.getLabelAttributesBy(keys: titleAttributedKeys)
        )
        catchCopyLabel.text = curriculum.catchCopy
        thumbnailImageView.image = UIImage(named: curriculum.thumbnailName)

        let detailAttributedKeys = UILabelDecorator.KeysForDecoration(
            lineSpacing: 5.0,
            font: UIFont(name: "HelveticaNeue-Bold", size: 11.0)!,
            foregroundColor: UIColor.darkGray
        )
        teacherNameLabel.attributedText = NSAttributedString(
            string: curriculum.teacherName,
            attributes: UILabelDecorator.getLabelAttributesBy(keys: detailAttributedKeys)
        )
        introductionLabel.attributedText = NSAttributedString(
            string: curriculum.introduction,
            attributes: UILabelDecorator.getLabelAttributesBy(keys: detailAttributedKeys)
        )
        termAndCourseCountLabel.attributedText = NSAttributedString(
            string: curriculum.lessonCount + "・" + curriculum.terms,
            attributes: UILabelDecorator.getLabelAttributesBy(keys: detailAttributedKeys)
        )
    }

    // MARK: - Private Function

    private func setupCurriculumTableViewCell() {
        showCourseButton.addTarget(self, action: #selector(self.showCourseButtonTapped), for: .touchUpInside)
    }

    @objc private func showCourseButtonTapped() {
        self.delegate?.showCourseButtonTappedHandler(curriculum: curriculum)
    }
}
