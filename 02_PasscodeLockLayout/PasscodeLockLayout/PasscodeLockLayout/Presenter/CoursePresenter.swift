//
//  CoursePresenter.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol CoursePresenterProtocol: class {
    func bindCourseModels(_ courseModels: [CourseModel])
}

final class CoursePresenter {

    // MARK: - Property

    private (set)var presenter: CoursePresenterProtocol!

    // MARK: - Initializer

    init(presenter: CoursePresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Private Function

    func getTravelModelsBy(curriculumId: Int) {
        self.presenter.bindCourseModels(getCourseModelsBy(curriculumId: curriculumId))
    }

    // MARK: - Private Function

    private func getCourseModelsBy(curriculumId: Int) -> [CourseModel] {

        // JSONファイルから表示用のデータを取得する
        guard let path = Bundle.main.path(forResource: "course\(curriculumId)", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let curriculumModels = try? JSONDecoder().decode([CourseModel].self, from: data) else {
            fatalError()
        }
        return curriculumModels
    }
}
