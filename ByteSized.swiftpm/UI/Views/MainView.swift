//  MainView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import Confetti
import SwiftData
import SwiftUI

struct MainView: View {
  @Namespace private var animation
  @State private var expandedCardId: Int?
  @Query private var completedLessons: [CompletedLesson]
  #if DEBUG
//  @State private var selectedLesson: Lesson? = LessonCourses.allCourses.filter { $0.id == 2 }.first?.lessons.first(where: { $0.id == 5 })
    @State private var selectedLesson: Lesson?
  #else
    @State private var selectedLesson: Lesson?
  #endif

  @Environment(\.modelContext) private var modelContext
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize

  @State private var confettiManager: ConfettiManager = .shared

  private var nextUncompletedLessonID: Int? {
    // Flatten all lessons in order and find the first that is not completed
    let completedIDs = Set(completedLessons.map { $0.lessonID })
    for course in LessonCourses.allCourses {
      for lesson in course.lessons {
        if !completedIDs.contains(lesson.id) {
          return lesson.id
        }
      }
    }
    return nil
  }

  var body: some View {
    Group {
      GeometryReader { geometry in
        let isLandscape = geometry.size.width > geometry.size.height
        if isLandscape {
        // iPad layout: keep existing horizontal carousels
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            ForEach(LessonCourses.allCourses) { course in
              VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                  Text(course.title)
                    .font(.title2).bold()

                  Text(course.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                  LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(course.lessons) { lesson in
                      let baseExpandedHeight = CGFloat(210 + ((lesson.slides.count) * 22))
                      let expandedHeight = baseExpandedHeight * dynamicTypeSize.scaleFactor
                      LessonCard(
                        lesson,
                        isNext: nextUncompletedLessonID == lesson.id
                      )
                      #if DEBUG
                        .contextMenu {
                          Button("Mark as completed") {
                            CompletedLesson.markLessonAsCompleted(
                              lessonID: lesson.id,
                              in: modelContext
                            )
                          }
                          Button("Unmark as completed") {
                            if let completedLesson = completedLessons.first(
                              where: { $0.lessonID == lesson.id })
                            {
                              modelContext.delete(completedLesson)
                              try? modelContext.save()
                            }
                          }
                        }
                      #endif
                      .frame(
                        width: expandedCardId == lesson.id ? 520 * dynamicTypeSize.scaleFactor : 400 * dynamicTypeSize.scaleFactor,
                        height: expandedCardId == lesson.id ? expandedHeight : 120 * dynamicTypeSize.scaleFactor,
                        alignment: .leading
                      )
                      .onTapGesture {
                        withAnimation(.bouncy(duration: 0.3)) {
                          expandedCardId =
                            (expandedCardId == lesson.id) ? nil : lesson.id
                        }
                      }
                      .matchedTransitionSource(id: lesson.id, in: animation)
                    }
                  }
                  .padding()
                }
                .frame(height: expandedCardId != nil && course.lessons.contains(where: { $0.id == expandedCardId }) ? (300 + 32) * dynamicTypeSize.scaleFactor : (120 + 32) * dynamicTypeSize.scaleFactor)
                .animation(.bouncy(duration: 0.3), value: expandedCardId)
              }
              .scrollTransition { content, phase in
                content
                  .opacity(phase.isIdentity ? 1 : 0)
                  .scaleEffect(phase.isIdentity ? 1 : 0.95)
                  .blur(radius: phase.isIdentity ? 0 : 10)
              }
            }
          }
          #if DEBUG
            Text("All Completed Lesson instances:")
            ForEach(completedLessons, id: \.lessonID) { completedLesson in
              Text("Lesson ID: \(completedLesson.lessonID)")
                .contextMenu {
                  Button("Delete") {
                    modelContext.delete(completedLesson)
                    try? modelContext.save()
                  }
                }
            }

            HStack {
              Button("Mark all as completed") {
                for course in LessonCourses.allCourses {
                  for lesson in course.lessons {
                    if !completedLessons.contains(where: {
                      $0.lessonID == lesson.id
                    }) {
                      CompletedLesson.markLessonAsCompleted(
                        lessonID: lesson.id,
                        in: modelContext
                      )
                    }
                  }
                }
              }

              Button("Unmark all as completed") {
                for completedLesson in completedLessons {
                  modelContext.delete(completedLesson)
                }
                try? modelContext.save()
              }
            }
          #endif
        }
      } else {
        // iPhone layout: vertical list, full-width cards, no horizontal scrolls
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            ForEach(LessonCourses.allCourses) { course in
              VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                  Text(course.title)
                    .font(.title3).bold()
                  Text(course.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                LazyVStack(spacing: 12) {
                  ForEach(course.lessons) { lesson in
                    LessonCardPhone(
                      lesson,
                      isNext: nextUncompletedLessonID == lesson.id
                    )
                    .frame(
                      maxWidth: .infinity,
                      minHeight: expandedCardId == lesson.id ? CGFloat(100 + ((lesson.slides.count) * 22)) * dynamicTypeSize.scaleFactor : 100 * dynamicTypeSize.scaleFactor,
                      maxHeight: expandedCardId == lesson.id ? CGFloat(300 + ((lesson.slides.count) * 22)) * dynamicTypeSize.scaleFactor : 120 * dynamicTypeSize.scaleFactor
                    )
                    .onTapGesture {
                      withAnimation(.bouncy(duration: 0.3)) {
                        expandedCardId = (expandedCardId == lesson.id) ? nil : lesson.id
                      }
                    }
                    .matchedTransitionSource(id: lesson.id, in: animation)
                    .padding(.horizontal)
                  }
                }
              }
            }
          }
        }
      }
      }
    }
    .padding(.top)
    .navigationTitle("ByteSized")
    .background(
      LinearGradient(
        gradient: Gradient(colors: [
          Colours.Icterine.opacity(0.5), Colours.LightGreen.opacity(0.5),
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .fullScreenCover(item: $selectedLesson) { lesson in
      LessonSheet(
        lesson: lesson,
        animation: animation,
        onClose: {
          selectedLesson = nil
          CompletedLesson.markLessonAsCompleted(
            lessonID: lesson.id,
            in: modelContext
          )
        },
        earlyClose: {
          selectedLesson = nil
        }
      )
      .confettiOverlay(
        isPresented: Binding(
          get: {
            confettiManager.isShowingConfetti
          },
          set: { newValue in
            confettiManager.isShowingConfetti = newValue
          }
        )
      ) {
        ConfettiView(
          emissionDuration: confettiManager.emissionDuration
        )
      }
      .interactiveDismissDisabled()
    }
  }
  
  @ViewBuilder
  private func LessonCardPhone(_ lesson: Lesson, isNext: Bool = false)
    -> some View
  {
    let isCompleted = completedLessons.contains(where: {
      $0.lessonID == lesson.id
    })
    VStack(alignment: .leading) {
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: "\(lesson.icon, default: "book")")
          .resizable()
          .scaledToFit()
          .frame(width: 28, height: 28)
          .symbolColorRenderingMode(.gradient)
        VStack(alignment: .leading, spacing: 2) {
          HStack {
            Text(lesson.title)
              .font(.headline)
              .lineLimit(2)
            Spacer()
            if isCompleted {
              Label("Completed", systemImage: "checkmark.seal.fill")
                .foregroundStyle(.green)
            }
          }
          Text(lesson.description)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(3)
        }
      }
      
      if expandedCardId == lesson.id {
        VStack(alignment: .leading, spacing: 6) {
          Text("Lab Rundown:")
            .font(.subheadline.bold())
          
          ForEach(lesson.slides, id: \.id) { slide in
            HStack(spacing: 8) {
              Image(systemName: slide.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .symbolColorRenderingMode(.gradient)
              Text(slide.title)
                .font(.subheadline)
            }
          }
        }
        .padding(.top, 4)
      }
      
      Spacer()
      
      if expandedCardId == lesson.id {
        Button(action: {
          selectedLesson = lesson
          expandedCardId = nil
        }) {
          Text("Begin Experiment!")
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
      }
    }
    .padding(12)
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 12))
    .overlay(
      Group {
        if isNext {
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.green, lineWidth: 3)
            .shadow(color: Color.green.opacity(0.3), radius: 4)
        }
      }
    )
  }

  @ViewBuilder
  private func LessonCard(_ lesson: Lesson, isNext: Bool = false) -> some View {
    let isCompleted = completedLessons.contains(where: {
      $0.lessonID == lesson.id
    })
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "\(lesson.icon, default: "book")")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          //          .foregroundStyle(.accentColor)
          .symbolColorRenderingMode(.gradient)

        VStack(alignment: .leading) {
          HStack(alignment: .center) {
            Text(lesson.title)
              .font(.headline)
              .padding(.bottom, 2)
            
            if isCompleted {
              Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
            }
          }
          Text(lesson.description)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
      
      if expandedCardId == lesson.id {
        VStack(alignment: .leading) {
          Text("Lab Rundown:")
            .font(.subheadline.bold())
          
          ForEach(lesson.slides, id: \.id) { slide in
            VStack(alignment: .leading) {
              HStack {
                Image(systemName: slide.icon)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 18, height: 18)
                  .symbolColorRenderingMode(.gradient)
                
                Text(slide.title)
                  .font(.subheadline)
              }
            }
          }
        }
        .padding(.top, 4)
      }
      
      Spacer()

      if expandedCardId == lesson.id {
        HStack {
          Button(action: {
            selectedLesson = lesson
            expandedCardId = nil
          }) {
            Text("Begin Experiment!")
              .font(.headline)
              .padding(.horizontal, 14)
              .padding(.vertical, 8)
              .background(.ultraThinMaterial, in: Capsule())
          }
          .buttonStyle(.plain)
          
          if isCompleted {
            Label("Completed", systemImage: "checkmark.seal.fill")
              .foregroundStyle(.green)
          }
        }
      }
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
    .overlay(
      Group {
        if isNext {
          RoundedRectangle(cornerRadius: 15)
            .stroke(Color.green, lineWidth: 4)
            .shadow(color: Color.green.opacity(0.4), radius: 6)
        }
      }
    )
  }
}

extension DynamicTypeSize {
  var scaleFactor: CGFloat {
    switch self {
    case .xSmall: return 0.8
    case .small: return 0.9
    case .medium: return 1.0
    case .large: return 1.1
    case .xLarge: return 1.2
    case .xxLarge: return 1.3
    case .xxxLarge: return 1.4
    case .accessibility1: return 1.5
    case .accessibility2: return 1.6
    case .accessibility3: return 1.7
    case .accessibility4: return 1.8
    case .accessibility5: return 1.9
    @unknown default: return 1.0
    }
  }
}

#Preview(traits: .landscapeLeft) {
  MainView()
}
