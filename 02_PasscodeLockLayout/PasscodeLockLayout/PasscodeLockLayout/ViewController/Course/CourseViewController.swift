//
//  CourseViewController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit
import PanModal
import SwipeCellKit

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

        // MEMO: SwipeCollectionViewCellDelegateの宣言
        cell.delegate = self

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

// MARK: - SwipeCollectionViewCellDelegate

extension CourseViewController: SwipeCollectionViewCellDelegate {

    // MARK: - Enum

    // セルをスワイプした際に表示される内容に関する定義
    private enum ActionDescriptor: CaseIterable {
        case readMore
        case reserveCourse
        case contactTeacher

        func getImage() -> UIImage {
            var sfSymbolName: String
            switch self {
            case .readMore:
                sfSymbolName = "doc.text.fill"
            case .reserveCourse:
                sfSymbolName = "bag.fill.badge.plus"
            case .contactTeacher:
                sfSymbolName = "envelope.fill"
            }
            return UIImage(
                systemName: sfSymbolName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .black)
                )!.withTintColor(UIColor(code: "#ef93b6"), renderingMode: .alwaysOriginal)
        }

        func getTitle() -> String {
            switch self {
            case .readMore:
                return "もっと読む"
            case .reserveCourse:
                return "講義予約"
            case .contactTeacher:
                return "講師へ質問"
            }
        }
    }

    // セル要素をスワイプした際に出現するメニューに関するものを設定する
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        // 右側のスワイプのみを許可する
        guard orientation == .right else { return nil }

        // 配置したセルをスワイプした時に現れる表示要素を押下した際に実行する処理
        let readMoreAction = SwipeAction(style: .default, title: nil, handler: { _, _ in
            print("「もっと読む」エリアが押下されました。")
        })
        let reserveCourseAction = SwipeAction(style: .default, title: nil, handler: { _, _ in
            print("「講義予約」エリアが押下されました。")
        })
        let contactTeacherAction = SwipeAction(style: .default, title: nil, handler: { _, _ in
            print("「講師へ質問」エリアが押下されました。")
        })

        // 配置したセルをスワイプした時に現れる表示要素へのデザイン適用処理
        setActionDesign(action: readMoreAction, with: .readMore)
        setActionDesign(action: reserveCourseAction, with: .reserveCourse)
        setActionDesign(action: contactTeacherAction, with: .contactTeacher)

        // MEMO: UIAlertControllerを利用する際のコード例(1)
        /*
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CourseCollectionViewCell
        let reserveCourseClosure: (UIAlertAction) -> Void = { _ in
            selectedCell.hideSwipe(animated: true)
        }
        let reserveCourseAction = SwipeAction(style: .default, title: "コース予約", handler: { action, indexPath in
            let controller = UIAlertController(title: "該当コースの予約はまだ始まっていません", message: "現在はまだ準備中です。開講1ヶ月前を目処に詳細な情報を掲載する予定ですので今しばらくお待ち下さい。", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: reserveCourseClosure))
            self.present(controller, animated: true, completion: nil)
        })
        setActionDesign(action: reserveCourseAction, with: .reserveCourse)
        */

        // MEMO: UIAlertControllerを利用する際のコード例(2)
        /*
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CourseCollectionViewCell
        let contactTeacherClosure: (UIAlertAction) -> Void = { _ in
            selectedCell.hideSwipe(animated: true)
        }
        let contactTeacherAction = SwipeAction(style: .default, title: "講師への質問", handler: { action, indexPath in
            let controller = UIAlertController(title: "質問の内容をお選び下さい", message: "内容に応じた相談ができます。", preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "講義内容に関する質問", style: .default, handler: contactTeacherClosure))
            controller.addAction(UIAlertAction(title: "課題提出に関する質問", style: .default, handler: contactTeacherClosure))
            controller.addAction(UIAlertAction(title: "講義予約に関する質問", style: .default, handler: contactTeacherClosure))
            controller.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: contactTeacherClosure))
            self.present(controller, animated: true, completion: nil)
        })
        setActionDesign(action: contactTeacherAction, with: .contactTeacher)
        */

        // MEMO: 配列の順番 = 右から並ぶ順番となる点に注意する
        return [readMoreAction, reserveCourseAction, contactTeacherAction]
    }

    // MARK: - Private Function

    private func setActionDesign(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.getTitle()
        action.image = descriptor.getImage()
        action.backgroundColor = .clear
        action.textColor = UIColor.darkGray
        action.font = .systemFont(ofSize: 11)
        action.transitionDelegate = ScaleTransition.default
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

    // MEMO: ライブラリ「PanModal」でのセミモーダル表示の実装ポイント
    // (1) 
    var longFormHeight: PanModalHeight {
        return .contentHeight(288.0)
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(288.0)
    }
}
