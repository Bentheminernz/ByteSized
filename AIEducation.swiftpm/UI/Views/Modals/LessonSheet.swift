//
//  LessonSheet.swift
//  AIEducation
//
//  Created by Ben Lawrence on 29/11/2025.
//

import SwiftUI

struct LessonSheet: View {
  let lesson: Lesson
  let animation: Namespace.ID
  let onClose: () -> Void

  @State private var currentIndex: Int = 0
  @State private var quizIndex: Int = 0
  @State private var selectedAnswerID: Int? = nil
  @State private var isAdvancing: Bool = true
  @State private var hasSubmitted: Bool = false
  @State private var showCompletion: Bool = false
  @State private var answersCorrect: Int = 0
  @State private var selectedAnswerIDsByQuestion: [Int?] = []

  #if targetEnvironment(simulator)
    @State var showHideSheetButton: Bool = true
  #endif

  var body: some View {
    let showingSlides = currentIndex < lesson.slides.count

    return Group {
      if showCompletion {
        LessonCompletionView(
          lesson: lesson,
          correct: answersCorrect,
          total: lesson.questions.count,
          onClose: onClose
        )
      } else {
        VStack(alignment: .leading, spacing: 16) {
          if showingSlides {
            if lesson.slides[currentIndex].hideHeader != true {
              SlideHeaderCard(slide: lesson.slides[currentIndex])
                .navigationTransition(.zoom(sourceID: lesson.id, in: animation))
            }

            Group {
              lesson.slides[currentIndex].content
            }
            .transition(
              isAdvancing
                ? .asymmetric(
                  insertion: .move(edge: .trailing),
                  removal: .move(edge: .leading)
                )
                : .asymmetric(
                  insertion: .move(edge: .leading),
                  removal: .move(edge: .trailing)
                )
            )
            //            .animation(.bouncy, value: currentIndex)
            .frame(maxHeight: .infinity)

//            Spacer()

            HStack {
              Button("Previous") {
                isAdvancing = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  withAnimation(.smooth) {
                    currentIndex = max(currentIndex - 1, 0)
                  }
                }
              }
              .buttonStyle(.glassProminent)
              .disabled(currentIndex == 0)

              Spacer()

              HStack {
                ForEach(0..<lesson.slides.count, id: \.self) { idx in
                  Capsule()
                    .fill(
                      idx == currentIndex
                        ? Color.green : Color.gray.opacity(0.5)
                    )
                    .frame(width: idx == currentIndex ? 40 : 15, height: 15)
                    .onTapGesture {
                      isAdvancing = (idx > currentIndex)
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.smooth) {
                          currentIndex = idx
                        }
                      }
                    }
                }

                Capsule()
                  .fill(Color.gray.opacity(0.5))
                  .frame(width: 15, height: 15)
                  .overlay(
                    Image(systemName: "questionmark")
                      .font(.system(size: 10, weight: .bold))
                      .foregroundStyle(.white)
                  )
                  .onTapGesture {
                    isAdvancing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                      withAnimation(.smooth) {
                        currentIndex = lesson.slides.count
                        quizIndex = 0
                        selectedAnswerID = nil
                        hasSubmitted = false
                        selectedAnswerIDsByQuestion = Array(
                          repeating: nil,
                          count: lesson.questions.count
                        )
                      }
                    }
                  }
              }
              .padding()
              .glassEffect(.clear.interactive(), in: .capsule)

              Spacer()

              Button("Next") {
                isAdvancing = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  withAnimation(.smooth) {
                    currentIndex = min(currentIndex + 1, lesson.slides.count)
                    if currentIndex == lesson.slides.count {
                      quizIndex = 0
                      selectedAnswerID = nil
                      hasSubmitted = false
                      selectedAnswerIDsByQuestion = Array(
                        repeating: nil,
                        count: lesson.questions.count
                      )
                    }
                  }
                }
              }
              .buttonStyle(.glassProminent)
              .disabled(currentIndex == lesson.slides.count)
            }
          } else {
            // MARK: - Questions phase
            VStack(alignment: .leading, spacing: 16) {
              HStack(spacing: 12) {
                Image(systemName: "questionmark.circle.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 48, height: 48)
                  .symbolColorRenderingMode(.gradient)
                Text("Questions")
                  .font(.title2).bold()
                Spacer()
              }
              .padding()
              .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))

              let question = lesson.questions[quizIndex]
              let correctAnswerID = question.answers.first(where: {
                $0.isCorrect
              })?.id

              VStack(alignment: .leading, spacing: 12) {
                Text(question.question)
                  .font(.headline)

                ForEach(question.answers) { answer in
                  HStack {
                    if hasSubmitted {
                      if answer.id == correctAnswerID {
                        Image(systemName: "checkmark.circle.fill")
                          .foregroundStyle(.green)
                      } else if selectedAnswerID == answer.id
                        && selectedAnswerID != correctAnswerID
                      {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(
                          .red
                        )
                      } else {
                        Image(systemName: "circle")
                      }
                    } else {
                      Image(
                        systemName: selectedAnswerID == answer.id
                          ? "largecircle.fill.circle" : "circle"
                      )
                    }
                    Text(answer.answer)
                    Spacer()

                    if hasSubmitted {
                      if answer.id == correctAnswerID {
                        Text("Correct Answer")
                          .font(.caption)
                          .foregroundStyle(.green)
                      } else if selectedAnswerID == answer.id
                        && selectedAnswerID != correctAnswerID
                      {
                        Text("Your Answer")
                          .font(.caption)
                          .foregroundStyle(.red)
                      }
                    }
                  }
                  .padding()
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(
                    {
                      if hasSubmitted {
                        if answer.id == correctAnswerID {
                          return Color.green.opacity(0.2)
                        } else if selectedAnswerID == answer.id
                          && selectedAnswerID != correctAnswerID
                        {
                          return Color.red.opacity(0.2)
                        } else {
                          return Color.gray.opacity(0.08)
                        }
                      } else {
                        return
                          (selectedAnswerID == answer.id
                          ? Color.green.opacity(0.15)
                          : Color.gray.opacity(0.08))
                      }
                    }(),
                    in: RoundedRectangle(cornerRadius: 12)
                  )
                  .glassEffect(
                    .regular.interactive(),
                    in: .rect(cornerRadius: 12)
                  )
                  .onTapGesture {
                    guard !hasSubmitted else { return }
                    withAnimation(.linear) {
                      selectedAnswerID = answer.id
                      if quizIndex < selectedAnswerIDsByQuestion.count {
                        selectedAnswerIDsByQuestion[quizIndex] = answer.id
                      }
                    }
                  }
                }
              }
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 15)
                  .fill(Color(.systemBackground).opacity(0.8))
                  .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 5,
                    x: 0,
                    y: 2
                  )
              )

              Spacer()

              HStack {
                Button("Previous") {
                  withAnimation(.smooth) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                      isAdvancing = false
                    }

                    if quizIndex == 0 {
                      currentIndex = max(lesson.slides.count - 1, 0)
                    } else {
                      quizIndex = max(quizIndex - 1, 0)
                      selectedAnswerID = nil
                      hasSubmitted = false
                      if quizIndex < selectedAnswerIDsByQuestion.count {
                        selectedAnswerID =
                          selectedAnswerIDsByQuestion[quizIndex]
                      }
                    }
                  }
                }
                .buttonStyle(.glassProminent)

                Spacer()

                HStack {
                  ForEach(0..<lesson.questions.count, id: \.self) { idx in
                    Capsule()
                      .fill(
                        idx == quizIndex ? Color.green : Color.gray.opacity(0.5)
                      )
                      .frame(width: idx == quizIndex ? 40 : 15, height: 15)
                      .onTapGesture {
                        withAnimation(.bouncy) {
                          isAdvancing = (idx > quizIndex)
                          quizIndex = idx
                          selectedAnswerID = nil
                          hasSubmitted = false
                          if idx < selectedAnswerIDsByQuestion.count {
                            selectedAnswerID = selectedAnswerIDsByQuestion[idx]
                          }
                        }
                      }
                  }
                }
                .padding()
                .glassEffect(.clear.interactive(), in: .capsule)

                Spacer()

                if !hasSubmitted {
                  Button("Submit") {
                    withAnimation(.smooth) {
                      hasSubmitted = true
                    }
                  }
                  .buttonStyle(.glassProminent)
                  .disabled(selectedAnswerID == nil)
                } else if quizIndex == lesson.questions.count - 1 {
                  Button("Finish") {
                    withAnimation(.smooth) {
                      let correctIDs = lesson.questions.map { q in
                        q.answers.first(where: { $0.isCorrect })?.id
                      }
                      var score = 0
                      for (i, sel) in selectedAnswerIDsByQuestion.enumerated() {
                        if i < correctIDs.count, let sel,
                          let correct = correctIDs[i], sel == correct
                        {
                          score += 1
                        }
                      }
                      answersCorrect = score
                      showCompletion = true
                    }
                  }
                  .buttonStyle(.glassProminent)
                  .disabled(
                    selectedAnswerIDsByQuestion.contains(where: { $0 == nil })
                  )
                } else {
                  Button("Next") {
                    withAnimation(.smooth) {
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isAdvancing = true
                      }
                      quizIndex = min(quizIndex + 1, lesson.questions.count - 1)
                      selectedAnswerID = nil
                      hasSubmitted = false
                      if quizIndex < selectedAnswerIDsByQuestion.count {
                        selectedAnswerID =
                          selectedAnswerIDsByQuestion[quizIndex]
                      }
                    }
                  }
                  .buttonStyle(.glassProminent)
                }
              }
            }
          }
        }
      }
    }
    .padding()
    .background(
      LinearGradient(
        gradient: Gradient(colors: [
          Color(.systemBackground), Color(.systemBackground).opacity(0.9),
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
    )
    #if DEBUG
      .onPencilSqueeze { phase in
        onClose()
      }
    #endif
    #if targetEnvironment(simulator)
      .overlay {
        if showHideSheetButton {
          VStack {
            Spacer()
            HStack {
              Button(action: {
                onClose()
              }) {
                Text("Close Lesson")
                  .padding(8)
                  .background(Color.black.opacity(0.5))
                  .foregroundStyle(.white)
                  .cornerRadius(8)
              }
              
              Button(action: {
                showHideSheetButton.toggle()
              }) {
                Text(
                  showHideSheetButton ? "Hide Close Button" : "Show Close Button"
                )
                .padding(8)
                .background(Color.black.opacity(0.5))
                .foregroundStyle(.white)
                .cornerRadius(8)
              }
            }
          }
        }
      }
    #endif
  }
}

struct SlideHeaderCard: View {
  let slide: Slide

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: slide.icon)
        .resizable()
        .scaledToFit()
        .frame(width: 48, height: 48)
        .symbolColorRenderingMode(.gradient)
        .contentTransition(.symbolEffect(.replace))
      
      Text(slide.title)
        .font(.title2).bold()
        .contentTransition(.numericText(value: Double(slide.id)))
      
      Spacer()
      
      if slide.containsCode {
        Text("Code Examples, feel free to skip if it's not your thing!")
          .padding(12)
          .glassEffect(.regular.tint(Colours.LightGreen.opacity(0.8)), in: .capsule)
      }
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
  }
}

struct LessonCompletionView: View {
  let lesson: Lesson
  let correct: Int
  let total: Int
  let onClose: () -> Void

  var message: String {
    let fractionCorrect = Double(correct) / Double(total)

    if fractionCorrect == 1.0 {
      return "Perfect score! 🎉"
    } else if fractionCorrect >= 2.0 / 3.0 {
      return "Great job! 👍"
    } else {
      return "Nearly there! Keep practicing! 🚀"
    }
  }

  @State private var confettiManager: ConfettiManager = .shared

  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "checkmark.seal.fill")
        .font(.system(size: 64))
        .foregroundStyle(.green)

      Text("Completed \(lesson.title)")
        .font(.title).bold()

      Text("Score: \(correct) / \(total)")
        .font(.headline)

      Text(message)
        .font(.subheadline)
        .foregroundStyle(.secondary)

      HStack {
        Button("Done") { onClose() }
          .buttonStyle(.glassProminent)
      }
    }
    .padding()
    .onAppear {
      if correct == total {
        confettiManager.start()
      }
    }
    .onDisappear {
      confettiManager.stop()
    }
  }
}

#Preview("Lesson Sheet", traits: .landscapeRight) {
  LessonSheet(
    lesson: LessonCourses.allCourses[2].lessons[0],
    animation: Namespace().wrappedValue,
    onClose: {}
  )
}

#Preview("Lesson Slide Header", traits: .landscapeRight) {
  SlideHeaderCard(slide: LessonCourses.allCourses[1].lessons[0].slides[3])
}
