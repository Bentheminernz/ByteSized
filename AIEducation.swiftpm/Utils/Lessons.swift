//
//  Lessons.swift
//  AIEduation
//
//  Created by Ben Lawrence on 07/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Make sure to come back and rewrite the descriptions!
@MainActor
struct LessonCourses {
  static let allCourses: [LessonCourse] = [
    LessonCourse(
      id: 1,
      title: "Foundations of AI",
      description: "What is AI? How does it work? Get started with the basics.",
      lessons: [
        Lesson(
          id: 1,
          icon: "thermometer",
          title: "What is AI?",
          description: "Let's explore the fundamentals of Artificial Intelligence and how it differs from other technologies.",
          slides: [
            AnyView(Text("AI"))
          ]
        ),
        Lesson(
          id: 2,
          icon: "book.fill",
          title: "How do machines learn?",
          description: "Discover the various machine learning techniques that enable computers to learn from data.",
          slides: [
            AnyView(Text("AI"))
          ]
        ),
        Lesson(
          id: 3,
          icon: "book.fill",
          title: "How does AI think?",
          description: "Understand the concepts behind neural networks and how they mimic human brain functions.",
          slides: [
            AnyView(Text("AI"))
          ]
        ),
      ]
    ),
    LessonCourse(
      id: 2,
      title: "Working with LLMs",
      description: "Dive into Large Language Models and learn how to harness their power.",
      lessons: [
        Lesson(
          id: 4,
          icon: "book.fill",
          title: "Tokens & Context",
          description: "Learn about tokens, context windows, and how they impact LLM performance.",
          slides: [
            AnyView(Text("AI"))
          ]
        ),
        Lesson(
          id: 5,
          icon: "thermometer",
          title: "Prompts & Parameters",
          description: "Explore prompt engineering techniques and model parameters to optimize outputs.",
          slides: [
            AnyView(TemperatureLesson())
          ]
        ),
        Lesson(
          id: 6,
          icon: "book.fill",
          title: "Master Prompt Engineering",
          description: "Become proficient in crafting effective prompts to get the best results from LLMs.",
          slides: [
            AnyView(Text("AI"))
          ]
        )
      ]
    ),
    LessonCourse(
      id: 3,
      title: "Multi-Modal AI",
      description: "Explore the exciting world of multi-modal AI and its applications.",
      lessons: [
        Lesson(
          id: 7,
          icon: "photo",
          title: "Image Generation",
          description: "Discover how AI can create stunning images from text prompts.",
          slides: [
            AnyView(IntroView()),
            AnyView(TrainingData()),
            AnyView(DemoView())
          ]
        ),
        Lesson(
          id: 8,
          icon: "photo",
          title: "AI Art & Ethics",
          description: "Delve into the ethical considerations surrounding AI-generated art and creativity.",
          slides: [
            AnyView(Text("AI"))
          ]
        ),
        Lesson(
          id: 9,
          icon: "camera",
          title: "Multi-Modal Models",
          description: "Learn about models that can process and generate multiple types of data, such as text and images.",
          slides: [
            AnyView(Text("AI"))
          ]
        )
      ]
    )
  ]
}

struct LessonCourse: Identifiable {
  let id: Int
  let title: String
  let description: String
  let lessons: [Lesson]
}

struct Lesson: Identifiable {
  let id: Int
  let icon: String?
  let title: String
  let description: String
  let slides: [AnyView]
}
