//
//  CompleteLesson.swift
//  AIEducation
//
//  Created by Ben Lawrence on 16/11/2025.
//

import Foundation
import SwiftData

@Model
class CompletedLesson {
    @Attribute(.unique) var lessonID: Int
    var completedAt: Date

    init(lessonID: Int, completedAt: Date = Date()) {
        self.lessonID = lessonID
        self.completedAt = completedAt
    }
}
