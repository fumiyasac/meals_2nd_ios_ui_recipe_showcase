//
//  CurriculumPresenter.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol CurriculumPresenterProtocol: class {
    func bindCurriculumModels(_ curriculumModels: [CurriculumModel])
}

final class CurriculumPresenter {

    // MARK: - Property

    private (set)var presenter: CurriculumPresenterProtocol!

    // MARK: - Initializer

    init(presenter: CurriculumPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Private Function

    func getCurriculumModels() {
        self.presenter.bindCurriculumModels(getCurriculumModels())
    }

    // MARK: - Private Function

    private func getCurriculumModels() -> [CurriculumModel] {

        // JSONファイルから表示用のデータを取得する
        guard let path = Bundle.main.path(forResource: "curriculum", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let curriculumModels = try? JSONDecoder().decode([CurriculumModel].self, from: data) else {
            fatalError()
        }
        return curriculumModels
    }
}
