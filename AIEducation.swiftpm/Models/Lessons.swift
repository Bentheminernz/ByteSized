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
          icon: "graduationcap",
          title: "How do machines learn?",
          description:
            "Discover the various machine learning techniques that enable computers to learn from data.",
          slides: [
            Slide(
              id: 1,
              title: "How do machines learn?",
              icon: "arrow.down.circle",
            ) {
              HowDoMachinesLearn1()
            },
            Slide(
              id: 2,
              title: "Ok so how does it know how to talk?",
              icon: "text.page.badge.magnifyingglass"
            ) {
              HowDoMachinesLearn2()
            },
            Slide(
              id: 3,
              title: "Makes sense, what about images?",
              icon: "rectangle.and.text.magnifyingglass"
            ) {
              HowDoMachinesLearn3()
            },
            Slide(
              id: 4,
              title: "If its trained on examples, how does it learn real patterns instead of just memorizing?",
              icon: "chart.line.uptrend.xyaxis"
            ) {
              HowDoMachinesLearn4()
            },
            Slide(
              id: 5,
              title: "Can I just feed it a few examples or does it need heaps?",
              icon: "brain.head.profile"
            ) {
              HowDoMachinesLearn5()
            }
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "How does AI learn to recognize patterns?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "By being exposed to many diverse examples",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "By memorizing every single image it sees",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "By reading instruction manuals",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "By randomly guessing until it gets it right",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "When AI looks at an image, what does it actually see?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Numbers representing pixel brightness and colors",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "The same thing humans see",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Words describing the image",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Nothing until it's trained",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 3,
              question: "What is the difference between training data and testing data?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Training data is used to learn, testing data checks performance on new examples",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Training data is fake, testing data is real",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "They are exactly the same thing",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Testing data is used first, then training data",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 4,
              question: "Why does AI need lots of training examples?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "To find real patterns instead of memorizing specific examples",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Because AI has poor memory",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "To make training take longer",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "It doesn't - one example is enough",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 5,
              question: "How does AI learn to predict the next word in a sentence?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "By reading millions of texts and noticing which words typically follow others",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "By using a dictionary to find random words",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "By asking humans for every single prediction",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "By counting the letters in each word",
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
              title: "What Are Tokens?",
              icon: "puzzlepiece.fill",
            ) {
              TokenContextLesson1()
            },
            Slide(
              id: 2,
              title: "Why Tokens Matter",
              icon: "lightbulb.max",
            ) {
              TokenContextLesson2()
            },
            Slide(
              id: 3,
              title: "Context Windows",
              icon: "rectangle.stack.fill",
            ) {
              TokenContextLesson3()
            },
            Slide(
              id: 4,
              title: "Window Sizes",
              icon: "chart.bar.fill",
            ) {
              TokenContextLesson4()
            },
            Slide(
              id: 5,
              title: "Practical Tips",
              icon: "star.fill",
            ) {
              TokenContextLesson5()
            }
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question: "What are tokens in AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Rewards you earn for using AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Small pieces that AI breaks text into for processing",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Special passwords for AI access",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Error messages from the AI",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question: "What is a context window?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "The screen where you type messages to AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "A window that shows AI's source code",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "The time limit for AI responses",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "The limited amount of text an AI can see and remember at once",
                  isCorrect: true
                ),
              ]
            ),
            LessonQuestion(
              id: 3,
              question: "What happens when a context window fills up?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "The AI starts forgetting older messages",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "The AI becomes smarter",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "The AI stops working completely",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Nothing - it can remember everything",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 4,
              question: "What's included in the context window?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Only your most recent message",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Everything ever typed to the AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Your messages, AI's responses, and system instructions",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Only the AI's training data",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 5,
              question: "Why is it helpful to be concise when prompting AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Because AI can't read long messages",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "To make the AI respond faster",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "It's not - longer is always better",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 1,
                  answer: "To save tokens and leave more room in the context window",
                  isCorrect: true
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
          description:
            "Explore how prompts and parameters influence LLM outputs.",
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
        // MARK: - Lesson 6
        Lesson(
          id: 6,
          icon: "hammer",
          title: "Tools",
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
              question:
                "What is the main purpose of giving AI models access to tools?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "To replace the need for training data entirely",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "To transform them from text generators into powerful assistants that can perform a wide range of tasks",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "To make them run faster and use less memory",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "To allow them to write their own code",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 2,
              question:
                "How does an AI model decide which tools to use when responding to a prompt?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "It automatically uses every tool that's available",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "The user must explicitly tell it which tools to use",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "It randomly selects tools to try",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer:
                    "It evaluates the request and determines if any tools can help generate a better informed response",
                  isCorrect: true
                ),
              ]
            ),

            LessonQuestion(
              id: 3,
              question:
                "What happens after a tool returns its result to the AI model?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer:
                    "The model reads and understands the result, may call more tools if needed, or crafts a final answer",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "The model immediately passes the raw result to the user",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "The tool result is saved for the next conversation",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "The session ends and resets",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 4,
              question: "What defines how a tool works for an AI model?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Only the programming language used to write it",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "The number of parameters it accepts",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer:
                    "A clear description of what it does and what information it needs to work",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer: "The size of the code file",
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
      title: "Advanced AI Topics",
      description:
        "Delve into specialized areas of AI including image generation, safety, and future applications.",
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
              icon: "photo.stack"
            ) {
              ImageGeneration2()
            },
            Slide(
              id: 3,
              title: "But how does it tell a cat from the sky?",
              icon: "photo.badge.magnifyingglass",
            ) {
              ImageGeneration3()
            },
            Slide(
              id: 4,
              title: "Ok enough stalling, show me a demo!",
              icon: "wand.and.sparkles",
            ) {
              ImageGeneration4()
            },
            Slide(
              id: 5,
              title: "How can I use this in my apps?",
              icon: "chevron.left.forwardslash.chevron.right",
              containsCode: true
            ) {
              ImageGeneration5()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question:
                "How is AI image generation similar to how AI generates text?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Both use magic to create new content",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "Both learn patterns from huge amounts of training data",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Both copy existing content from the internet",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Both require a human to guide every decision",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 2,
              question:
                "How does an AI image model know what a cat or tree looks like?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer:
                    "Programmers manually describe every object to the AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "It guesses based on random combinations",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer:
                    "It learns from images that have text descriptions explaining what's in them",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer:
                    "It searches the internet each time it needs to draw something",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 3,
              question:
                "What type of information do AI image models learn from during training?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Only the colors in images",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "Patterns, colors, shapes, objects, and their relationships",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Just the size and resolution of images",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Only text descriptions without actual images",
                  isCorrect: false
                ),
              ]
            ),
            LessonQuestion(
              id: 4,
              question:
                "Why are text captions important when training AI image generation models?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer:
                    "They help the model understand what objects are and where they appear in images",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "They tell the model what colors to use",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "They are not important, models only need images",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "They control the size of the generated image",
                  isCorrect: false
                ),
              ]
            ),
          ]
        ),
        // MARK: - Lesson 8
        Lesson(
          id: 8,
          icon: "brain.head.profile",
          title: "AI Safety & Bias",
          description:
            "Understand the ethical considerations and challenges in AI development.",
          slides: [
            Slide(
              id: 1,
              title: "AI Bias?? What even is that?",
              icon: "brain.head.profile",
            ) {
              AISafetyBias1()
            },
            Slide(
              id: 2,
              title: "So what does it look like?",
              icon: "person.crop.square.badge.camera",
            ) {
              AISafetyBias2()
            },
            Slide(
              id: 3,
              title: "How do we fix it?",
              icon: "checkmark.shield",
            ) {
              AISafetyBias3()
            },
            Slide(
              id: 4,
              title: "How can we make AI safer?",
              icon: "heart.circle",
            ) {
              AISafetyBias4()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question:
                "If an AI system for screening job applications mostly learned from past hires who went to certain schools, what might happen?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "The AI will choose the best candidate every time",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "Qualified candidates from other backgrounds might be unfairly overlooked",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "The AI will work slower than expected",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Nothing, because AI is always objective",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 2,
              question:
                "According to the lesson, how does AI learn patterns and biases?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Programmers manually tell the AI what to think",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "From the training data it learns from, just like eating pizza from only one restaurant",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "AI makes random guesses until it gets things right",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "The AI invents its own biases independently",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 3,
              question:
                "What is one way that having diverse teams helps reduce AI bias?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "It makes the AI run faster",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "It reduces the cost of development",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer:
                    "Different perspectives help catch biases that others might miss",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer: "It's not actually helpful for reducing bias",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 4,
              question:
                "What can you do as a user when you notice biased or unfair AI behavior?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Report it - your feedback matters!",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Nothing, because AI can't be changed",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Assume the AI must be right since it's technology",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Stop using all technology completely",
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
          title: "AI & The Future",
          description:
            "Explore the potential future careers and applications of AI technology.",
          slides: [
            Slide(
              id: 1,
              title: "What does the future hold for AI?",
              icon: "clock"
            ) {
              AIFutureCareers1()
            },
            Slide(
              id: 2,
              title: "What about industry-specific jobs?",
              icon: "briefcase.fill"
            ) {
              AIFutureCareers2()
            },
            Slide(
              id: 3,
              title: "What new opportunities could arise?",
              icon: "lightbulb.max"
            ) {
              AIFutureCareers3()
            },
            Slide(
              id: 4,
              title: "What can I do now?",
              icon: "star.fill"
            ) {
              AIFutureCareers4()
            },
          ],
          questions: [
            LessonQuestion(
              id: 1,
              question:
                "According to the lesson, how has AI changed in just the past 10 years?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "It hasn't changed much at all",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "AI assistants went from science fiction to everyday use",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "AI became less useful than before",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Only scientists can use AI now",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 2,
              question: "What does an AI Ethics Specialist do?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Only write code for AI systems",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer:
                    "Make sure AI systems are fair, safe, and beneficial for everyone",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 3,
                  answer: "Design video games",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Teach AI to students",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 3,
              question:
                "According to the lesson, what's true about preparing for an AI future?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "You must be a math genius to work with AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Only coding experts can use AI",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer:
                    "You can work with AI no matter what you're interested in",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer: "You need to choose between AI or your passions",
                  isCorrect: false
                ),
              ]
            ),

            LessonQuestion(
              id: 4,
              question:
                "According to the lesson, who is shaping the future of AI?",
              answers: [
                LessonAnswer(
                  id: 1,
                  answer: "Only scientists in labs",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 2,
                  answer: "Only tech companies",
                  isCorrect: false
                ),
                LessonAnswer(
                  id: 3,
                  answer: "People from all backgrounds with diverse interests",
                  isCorrect: true
                ),
                LessonAnswer(
                  id: 4,
                  answer: "Only adults with college degrees",
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
