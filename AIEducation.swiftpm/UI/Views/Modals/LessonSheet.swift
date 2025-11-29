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

  var body: some View {
    let showingSlides = currentIndex < lesson.slides.count

    return VStack(alignment: .leading, spacing: 16) {
      if showingSlides {
        if lesson.slides[currentIndex].hideHeader != true {
          SlideHeaderCard(slide: lesson.slides[currentIndex])
            .navigationTransition(.zoom(sourceID: lesson.id, in: animation))
        }

        Group {
          lesson.slides[currentIndex].content
        }
        .transition(isAdvancing ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)) : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
//        .animation(.bouncy, value: currentIndex)
        .frame(maxHeight: .infinity)

        Spacer()

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
                .fill(idx == currentIndex ? Color.green : Color.gray.opacity(0.5))
                .frame(width: idx == currentIndex ? 40 : 15, height: 15)
            }
            
            Capsule()
              .fill(Color.gray.opacity(0.5))
              .frame(width: 15, height: 15)
              .overlay(
                Image(systemName: "questionmark")
                  .font(.system(size: 10, weight: .bold))
                  .foregroundStyle(.white)
              )
          }
          .padding()
          .glassEffect(.clear.interactive(), in: .capsule)

          Spacer()

          Button("Next") {
            isAdvancing = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              withAnimation(.smooth) {
                currentIndex = min(currentIndex + 1, lesson.slides.count)
              }
            }
          }
          .buttonStyle(.glassProminent)
          .disabled(currentIndex == lesson.slides.count)
        }
      } else {
        // Questions phase
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

          VStack(alignment: .leading, spacing: 12) {
            Text(question.question)
              .font(.headline)

            ForEach(question.answers) { answer in
              Button(action: {
                withAnimation(.snappy) {
                  selectedAnswerID = answer.id
                }
              }) {
                HStack {
                  Image(systemName: selectedAnswerID == answer.id ? "largecircle.fill.circle" : "circle")
                  Text(answer.answer)
                  Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                  (selectedAnswerID == answer.id ? Color.green.opacity(0.15) : Color.gray.opacity(0.08)), in: RoundedRectangle(cornerRadius: 12)
                )
              }
              .buttonStyle(.plain)
            }
          }
          .padding()
          .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))

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
                }
              }
            }
            .buttonStyle(.glassProminent)

            Spacer()

            HStack {
              ForEach(0..<lesson.questions.count, id: \.self) { idx in
                Capsule()
                  .fill(idx == quizIndex ? Color.green : Color.gray.opacity(0.5))
                  .frame(width: idx == quizIndex ? 40 : 15, height: 15)
                  .onTapGesture {
                    withAnimation(.bouncy) {
                      isAdvancing = (idx > quizIndex)
                      quizIndex = idx
                      selectedAnswerID = nil
                    }
                  }
              }
            }
            .padding()
            .glassEffect(.clear.interactive(), in: .capsule)

            Spacer()

            if quizIndex == lesson.questions.count - 1 {
              Button("Finish") {
                withAnimation(.smooth) {
                  onClose()
                }
              }
              .buttonStyle(.glassProminent)
              .disabled(selectedAnswerID == nil)
            } else {
              Button("Next") {
                withAnimation(.smooth) {
                  if selectedAnswerID != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                      isAdvancing = true
                    }
                    quizIndex = min(quizIndex + 1, lesson.questions.count - 1)
                    selectedAnswerID = nil
                  }
                }
              }
              .buttonStyle(.glassProminent)
              .disabled(selectedAnswerID == nil)
            }
          }
        }
      }
    }
    .padding()
    .background(
      LinearGradient(
        gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.9)]),
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
      Text(slide.title)
        .font(.title2).bold()
      Spacer()
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
  }
}
