//
//  CurriculumTableViewCell.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class CurriculumTableViewCell: UITableViewCell {

    // MARK: - Property
    
    private var curriculum: CurriculumModel? = nil
    private var indexPath: IndexPath? = nil

    // MARK: - @IBOutlet

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var catchCopyLabel: UILabel!
    @IBOutlet private weak var toggleCursorImageView: UIImageView!
    @IBOutlet private weak var toggleButton: UIButton!
    @IBOutlet private weak var toggleLabel: UILabel!
    @IBOutlet private weak var detailWrappedView: UIView!
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

    private func setCell(_ curriculum: CurriculumModel) {
        
    }

    // MARK: - Private Function

    private func setupCurriculumTableViewCell() {
        
    }
}
