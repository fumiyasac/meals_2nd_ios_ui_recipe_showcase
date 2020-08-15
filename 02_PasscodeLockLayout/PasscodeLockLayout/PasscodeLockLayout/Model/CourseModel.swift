//
//  CourseModel.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation

struct CourseModel: Decodable {

    let courseId: Int
    let courseTitle: String
    let courseTerm: String
    
    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case courseId = "course_id"
        case courseTitle = "course_title"
        case courseTerm = "course_term"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.courseId = try container.decode(Int.self, forKey: .courseId)
        self.courseTitle = try container.decode(String.self, forKey: .courseTitle)
        self.courseTerm = try container.decode(String.self, forKey: .courseTerm)
    }
}
