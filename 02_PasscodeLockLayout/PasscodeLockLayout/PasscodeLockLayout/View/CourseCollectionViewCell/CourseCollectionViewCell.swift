//
//  CourseCollectionViewCell.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import SwipeCellKit

// MEMO: UICollectionViewでもUITableViewの様にスワイプ時にメニューを表示する
// → ライブラリ「SwipeCellKit」で提供されているクラスSwipeCollectionViewCellを継承してセルを構築する
// ※ ライブラリ「SwipeCellKit」はUITableViewでも利用することができます。

final class CourseCollectionViewCell: SwipeCollectionViewCell {

    // MARK: - Property

    static let cellSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 72.0)

    // MARK: - @IBOutlet

    @IBOutlet private weak var courseTitleLabel: UILabel!
    @IBOutlet private weak var courseTermLabel: UILabel!

    // MARK: - Function

    func setCell(_ course: CourseModel) {
        courseTitleLabel.text = course.courseTitle
        courseTermLabel.text = course.courseTerm
    }
}
