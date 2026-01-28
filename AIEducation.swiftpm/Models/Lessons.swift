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
          description:
            "Let's explore the fundamentals of Artificial Intelligence and how it differs from other technologies.",
          slides: [
            Slide(
              id: 1,
              title: "What is AI?",
              icon: "thermometer",
            ) {
              WhatIsAILesson1()
            },
            Slide(
              id: 2,
              title: "Artificial Intelligence",
              icon: "brain",
            ) {
              WhatIsAILesson2()
            },
            Slide(
              id: 3,
              title: "Machine Learning",
              icon: "cpu",
            ) {
              WhatIsAILesson3()
            },
            Slide(
              id: 4,
              title: "Deep Learning",
              icon: "network",
            ) {
              WhatIsAILesson4()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 3,
              question: "What is Deep Learning?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer:
                    "A subset of Machine Learning that uses neural networks",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "A type of cloud computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "A programming language for AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "A hardware component for AI processing",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 2
        Lesson(
          id: 2,
          icon: "book.fill",
          title: "How do machines learn?",
          description:
            "Discover the various machine learning techniques that enable computers to learn from data.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
            ) {
              HowDoMachinesLearn1()
            },
            Slide(
              id: 2,
              title: "Supervised Learning",
              icon: "book.fill",
            ) {
              HowDoMachinesLearnPage2()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 3
        Lesson(
          id: 3,
          icon: "book.fill",
          title: "Tokens & Context",
          description:
            "Learn about tokens, context windows, and how they impact AI performance.",
          slides: [
            Slide(
              id: 1,
              title: "Tokens",
              icon: "book.fill",
            ) {
              TokenContextLesson1()
            },
            Slide(
              id: 2,
              title: "Context Windows",
              icon: "book.fill",
            ) {
              TokenContextLesson2()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
      ]
    ),
    LessonCourse(
      id: 2,
      title: "Working with LLMs",
      description:
        "Dive into Large Language Models and learn how to harness their power.",
      lessons: [
        // MARK: - Lesson 4
        Lesson(
          id: 4,
          icon: "square.stack.3d.up",
          title: "Guided Generation",
          description:
            "Understand guided generation techniques to control AI outputs effectively.",
          slides: [
            Slide(
              id: 1,
              title: "The Problem",
              icon: "wrench.and.screwdriver",
            ) {
              GuidedGeneration1()
            },
            Slide(
              id: 2,
              title: "For example...",
              icon: "lightbulb.max"
            ) {
              GuidedGeneration2()
            },
            Slide(
              id: 3,
              title: "But why?",
              icon: "exclamationmark.questionmark"
            ) {
              GuidedGeneration3()
            },
            Slide(
              id: 4,
              title: "How do I do that??",
              icon: "hammer",
              containsCode: true
            ) {
              GuidedGeneration4()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "In what application would you use guided generation?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "In a general chatbot application",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "In a game with dynamic character generation",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "In a text summarization tool",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "In a language translation app",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "What is the main goal of guided generation?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "To make AI sound more human",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "To make AI write in a predictable, structured way",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "To make the app run faster",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "To remove all creativity from AI",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 3,
              question: "Why is unstructured AI text hard for apps to use?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Because phones can't read text",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Because text is always wrong",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Because text uses too much storage",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer:
                    "Because the text can change and is hard to reliably pick apart",
                  isCorrect: true
                ),
              ]
            ),
            LessonQuestion(
              id: 4,
              question: "Which is an example of a structured output?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer:
                    "A recipe with clear fields like name, ingredients, and steps",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "A long paragraph describing a meal",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "A poem about cooking",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "A random list of words",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 5
        Lesson(
          id: 5,
          icon: "thermometer",
          title: "Prompts & Parameters",
          description: "Explore how prompts and parameters influence LLM outputs.",
          slides: [
            Slide(
              id: 1,
              title: "What affects AI outputs?",
              icon: "slider.horizontal.3",
            ) {
              PromptsAndParameters1()
            },
            Slide(
              id: 2,
              title: "The Perfect Prompt",
              icon: "character.cursor.ibeam"
            ) {
              PromptsAndParameters2()
            },
            Slide(
              id: 3,
              title: "Is it getting hot in here?",
              icon: "thermometer"
            ) {
              PromptsAndParameters3()
            }
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 6
        Lesson(
          id: 6,
          icon: "book.fill",
          title: "Tools (master prompt engineering)",
          description:
            "Unlock the full potential of LLMs with agentic tools!",
          slides: [
            Slide(
              id: 1,
              title: "A tool?? For an AI?",
              icon: "hammer",
            ) {
              Tools1()
            },
            Slide(
              id: 2,
              title: "That sounds awesome! Show me more!",
              icon: "sparkles"
            ) {
              Tools2()
            },
            Slide(
              id: 3,
              title: "Woahhhh, that was amazing!! How does it work??",
              icon: "brain.head.profile"
            ) {
              Tools3()
            },
            Slide(
              id: 4,
              title: "Ok enough teasing, how do I use this??",
              icon: "book.fill",
              containsCode: true
            ) {
              Tools4()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
      ]
    ),
    LessonCourse(
      id: 3,
      title: "Multi-Modal AI",
      description:
        "Explore the exciting world of multi-modal AI and its applications.",
      lessons: [
        // MARK: - Lesson 7
        Lesson(
          id: 7,
          icon: "photo",
          title: "Image Generation",
          description:
            "Discover how AI can create stunning images from text prompts.",
          slides: [
            Slide(
              id: 1,
              title: "Surely AI can generate more than just text?",
              icon: "photo",
            ) {
              ImageGeneration1()
            },
            Slide(
              id: 2,
              title: "Ok but like how does it know what stuff looks like?",
              icon: "photo",
            ) {
              ImageGeneration2()
            },
            Slide(
              id: 3,
              title: "Time to blow your mind!",
              icon: "photo",
              hideHeader: true
            ) {
              ImageGeneration3()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 8
        Lesson(
          id: 8,
          icon: "photo",
          title: "AI Art & Ethics",
          description:
            "Delve into the ethical considerations surrounding AI-generated art and creativity.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
            ) {
              Text("AI")
            }
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 9
        Lesson(
          id: 9,
          icon: "camera",
          title: "Multi-Modal Models",
          description:
            "Learn about models that can process and generate multiple types of data, such as text and images.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "book.fill",
            ) {
              Text("AI")
            }
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What does AI stand for?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Artificial Intelligence",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Automated Interaction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Advanced Integration",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Applied Informatics",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "Which of the following is a subset of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Machine Learning",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Quantum Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Cloud Computing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Internet of Things",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
      ]
    ),
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
  private let _content: () -> AnyView
  var hideHeader: Bool = false
  var containsCode: Bool = false

  init<Content: View>(
    id: Int,
    title: String,
    icon: String,
    hideHeader: Bool = false,
    containsCode: Bool = false,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.id = id
    self.title = title
    self.icon = icon
    self.hideHeader = hideHeader
    self.containsCode = containsCode
    self._content = { AnyView(content()) }
  }

  @ViewBuilder
  var content: some View {
    _content()
  }
}
