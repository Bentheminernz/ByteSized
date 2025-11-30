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
  
  static func markLessonAsCompleted(lessonID: Int, in context: ModelContext) {
    let completedLesson = CompletedLesson(lessonID: lessonID)
    context.insert(completedLesson)
    try? context.save()
  }
  
  @MainActor
  static func areAllLessonsCompleted(completedLessons: [CompletedLesson]) -> Bool {
    let allLessonIDs = LessonCourses.allCourses.flatMap { course in
      course.lessons.map { $0.id }
    }
    
    let completedLessonIDs = Set(completedLessons.map { $0.lessonID })
    
    return allLessonIDs.allSatisfy { completedLessonIDs.contains($0) }
  }
}
