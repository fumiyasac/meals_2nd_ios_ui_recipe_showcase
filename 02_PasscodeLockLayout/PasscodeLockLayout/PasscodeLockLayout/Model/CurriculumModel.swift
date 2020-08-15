//
//  CurriculumModel.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct CurriculumModel: Decodable {

    let curriculumId: Int
    let title: String
    let catchCopy: String
    let thumbnailName: String
    let teacherName: String
    let introduction: String
    let lessonCount: String
    let terms: String
    
    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case curriculumId = "curriculum_id"
        case title
        case catchCopy = "catch_copy"
        case thumbnailName = "thumbnail_name"
        case teacherName = "teacher_name"
        case introduction
        case lessonCount = "lesson_count"
        case terms
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.curriculumId = try container.decode(Int.self, forKey: .curriculumId)
        self.title = try container.decode(String.self, forKey: .title)
        self.catchCopy = try container.decode(String.self, forKey: .catchCopy)
        self.thumbnailName = try container.decode(String.self, forKey: .thumbnailName)
        self.teacherName = try container.decode(String.self, forKey: .teacherName)
        self.introduction = try container.decode(String.self, forKey: .introduction)
        self.lessonCount = try container.decode(String.self, forKey: .lessonCount)
        self.terms = try container.decode(String.self, forKey: .terms)
    }
}
