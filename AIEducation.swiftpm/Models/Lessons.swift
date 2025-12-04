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
        // MARK: - Lesson 1
        Lesson(
          id: 1,
          icon: "thermometer",
          title: "What is AI?",
          description: "Let's explore the fundamentals of Artificial Intelligence and how it differs from other technologies.",
          slides: [
            Slide(
              id: 1,
              title: "What is AI?",
              icon: "thermometer",
              content: AnyView(WhatIsAILesson1()),
//              hideHeader: true
              
            ),
            Slide(
              id: 2,
              title: "Artificial Intelligence",
              icon: "brain",
              content: AnyView(WhatIsAILesson2())
            ),
            Slide(
              id: 3,
              title: "Machine Learning",
              icon: "cpu",
              content: AnyView(WhatIsAILesson3())
            ),
            Slide(
              id: 4,
              title: "Deep Learning",
              icon: "network",
              content: AnyView(WhatIsAILesson4())
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 2
        Lesson(
          id: 2,
          icon: "book.fill",
          title: "How do machines learn?",
          description: "Discover the various machine learning techniques that enable computers to learn from data.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(HowDoMachinesLearn1())
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 3
        Lesson(
          id: 3,
          icon: "book.fill",
          title: "How does AI think?",
          description: "Understand the concepts behind neural networks and how they mimic human brain functions.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(Text("AI"))
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
      ]
    ),
    LessonCourse(
      id: 2,
      title: "Working with LLMs",
      description: "Dive into Large Language Models and learn how to harness their power.",
      lessons: [
        // MARK: - Lesson 4
        Lesson(
          id: 4,
          icon: "book.fill",
          title: "Tokens & Context",
          description: "Learn about tokens, context windows, and how they impact LLM performance.",
          slides: [
            Slide(
              id: 1,
              title: "Tokens",
              icon: "book.fill",
              content: AnyView(TokenContextLesson1())
            ),
            Slide(
              id: 2,
              title: "Context Windows",
              icon: "book.fill",
              content: AnyView(TokenContextLesson2())
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 5
        Lesson(
          id: 5,
          icon: "thermometer",
          title: "Prompts & Parameters",
          description: "Explore prompt engineering techniques and model parameters to optimize outputs.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(PromptsAndParameters1())
            ),
            Slide(
              id: 2,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(PromptsAndParameters2())
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 6
        Lesson(
          id: 6,
          icon: "book.fill",
          title: "Master Prompt Engineering",
          description: "Become proficient in crafting effective prompts to get the best results from LLMs.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(Text("AI"))
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        )
      ]
    ),
    LessonCourse(
      id: 3,
      title: "Multi-Modal AI",
      description: "Explore the exciting world of multi-modal AI and its applications.",
      lessons: [
        // MARK: - Lesson 7
        Lesson(
          id: 7,
          icon: "photo",
          title: "Image Generation",
          description: "Discover how AI can create stunning images from text prompts.",
          slides: [
            Slide(
              id: 1,
              title: "Image Generation",
              icon: "photo",
              content: AnyView(IntroView())
            ),
            Slide(
              id: 2,
              title: "Training Data",
              icon: "photo",
              content: AnyView(TrainingData())
            ),
            Slide(
              id: 3,
              title: "Demo",
              icon: "photo",
              content: AnyView(DemoView()),
              hideHeader: true
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 8
        Lesson(
          id: 8,
          icon: "photo",
          title: "AI Art & Ethics",
          description: "Delve into the ethical considerations surrounding AI-generated art and creativity.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(Text("AI"))
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
          ]
        ),
        // MARK: - Lesson 9
        Lesson(
          id: 9,
          icon: "camera",
          title: "Multi-Modal Models",
          description: "Learn about models that can process and generate multiple types of data, such as text and images.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
              content: AnyView(Text("AI"))
            )
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(id: 1, answer: "Artificial Intelligence", isCorrect: true),
                LessonAnswer(id: 2, answer: "Automated Interaction", isCorrect: false),
                LessonAnswer(id: 3, answer: "Advanced Integration", isCorrect: false),
                LessonAnswer(id: 4, answer: "Applied Informatics", isCorrect: false)
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(id: 1, answer: "Machine Learning", isCorrect: true),
                LessonAnswer(id: 2, answer: "Quantum Computing", isCorrect: false),
                LessonAnswer(id: 3, answer: "Cloud Computing", isCorrect: false),
                LessonAnswer(id: 4, answer: "Internet of Things", isCorrect: false)
              ]
            )
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
  let slides: [Slide]
  let questions: [LessonQuestion]
}

struct LessonQuestion: Identifiable {
  let id: Int
  let question: String
  let answers: [LessonAnswer]
}

struct LessonAnswer: Identifiable {
  let id: Int
  let answer: String
  let isCorrect: Bool
}

struct Slide: Identifiable {
  let id: Int
  let title: String
  let icon: String
  let content: AnyView
  var hideHeader: Bool? = false
}
