//
//  CourseViewController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import PanModal

final class CourseViewController: UIViewController {

    private var courses: [CourseModel] = []

    private var curriculum: CurriculumModel!

    // CoursePresenterProtocolに設定したプロトコルを適用するための変数
    private var presenter: CoursePresenter!

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCourseCollectionView ()
        setupCoursePresenter()
    }

    // MARK: - Function

    func setCurriculum(_ curriculum: CurriculumModel) {
        self.curriculum = curriculum
    }

    // MARK: - Private Function

    // 表示するUICollectionViewに関する設定を行う
    private func setupCourseCollectionView() {

        // MEMO: Interface BuilderでUICollectionViewの「Estimate Size」をNoneにする必要があります。
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(CourseCollectionViewCell.self)
    }

    // Presenterとの接続に関する設定を行う
    private func setupCoursePresenter() {
        presenter = CoursePresenter(presenter: self)
        presenter.getCourseModelsBy(curriculumId: curriculum.curriculumId)
    }
}

// MARK: - UICollectionViewDelegate

extension CourseViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension CourseViewController: UICollectionViewDataSource {

    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }

    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CourseCollectionViewCell.self, indexPath: indexPath)
        cell.setCell(courses[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseViewController: UICollectionViewDelegateFlowLayout {

    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CourseCollectionViewCell.cellSize
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }

    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - CoursePresenterProtocol

extension CourseViewController: CoursePresenterProtocol {

    func bindCourseModels(_ courseModels: [CourseModel]) {
        courses = courseModels
        collectionView.reloadData()
    }
}

// MARK: - PanModalPresentable

extension CourseViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return collectionView
    }

    var allowsDragToDismiss: Bool {
        return true
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(288.0)
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(288.0)
    }
}
