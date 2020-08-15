//
//  CurriculumViewController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class CurriculumViewController: UIViewController {

    // MARK: - Property

    private var curriculums: [CurriculumModel] = []

    // CurriculumPresenterProtocolに設定したプロトコルを適用するための変数
    private var presenter: CurriculumPresenter!

    // MARK: - @IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("Curriculum")
        removeBackButtonText()
        setupCurriculumTableView()
        setupCurriculumPresenter()
    }

    // MARK: - Private Function

    // 表示するUITableViewに関する設定を行う
    private func setupCurriculumTableView() {

        // MEMO: estimatedRowHeight = セルを非表示にしている場合の最小高さ
        tableView.estimatedRowHeight = 242.5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delaysContentTouches = false
        tableView.registerCustomCell(CurriculumTableViewCell.self)
    }

    // Presenterとの接続に関する設定を行う
    private func setupCurriculumPresenter() {
        presenter = CurriculumPresenter(presenter: self)
        presenter.getCurriculumModels()
    }
}

// MARK: - CurriculumPresenterProtocol

extension CurriculumViewController: CurriculumPresenterProtocol {

    func bindCurriculumModels(_ curriculumModels: [CurriculumModel]) {
        curriculums = curriculumModels
        tableView.reloadData()
    }
}
