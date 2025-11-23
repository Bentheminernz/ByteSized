//
//  MainView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI

struct MainView: View {
  @Namespace private var animation
  @State private var expandedCardId: Int?
  #if DEBUG
  @State private var selectedLesson: Lesson? = LessonCourses.allCourses.filter { $0.id == 2 }.first?.lessons.first
  #else
  @State private var selectedLesson: Lesson?
  #endif
  
  var body: some View {
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
              LazyHStack(spacing: 16) {
                ForEach(course.lessons) { lesson in
                  LessonCard(lesson)
                    .frame(width: expandedCardId == lesson.id ? 520 : 400, height: expandedCardId == lesson.id ? 180 : 120)
                    .onTapGesture {
                      withAnimation(.bouncy(duration: 0.3)) {
                        expandedCardId = (expandedCardId == lesson.id) ? nil : lesson.id
                      }
                    }
                    .matchedTransitionSource(id: lesson.id, in: animation)
                }
              }
              .padding()
            }
          }
          .scrollTransition { content, phase in
            content
              .opacity(phase.isIdentity ? 1 : 0)
              .scaleEffect(phase.isIdentity ? 1 : 0.95)
              .blur(radius: phase.isIdentity ? 0 : 10)
          }
        }
      }
    }
    .padding(.top)
    .navigationTitle("AI Education")
    .background(
      LinearGradient(
        gradient: Gradient(colors: [Colours.Icterine.opacity(0.5), Colours.LightGreen.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .fullScreenCover(item: $selectedLesson) { lesson in
      LessonSheet(lesson: lesson, animation: animation, onClose: { selectedLesson = nil })
        .interactiveDismissDisabled()
    }
  }
  
  @ViewBuilder
  private func LessonCard(_ lesson: Lesson) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "\(lesson.icon, default: "book")")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
//          .foregroundStyle(.accentColor)
          .symbolColorRenderingMode(.gradient)
        
        VStack(alignment: .leading) {
          Text(lesson.title)
            .font(.headline)
            .padding(.bottom, 2)
          Text(lesson.description)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
      Spacer()
      
      if expandedCardId == lesson.id {
        Button(action: {
          selectedLesson = lesson
          expandedCardId = nil
        }) {
          Text("Start Lesson")
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
      }
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
  }
}

struct LessonSheet: View {
  let lesson: Lesson
  let animation: Namespace.ID
  let onClose: () -> Void
  
  @State private var currentIndex: Int = 0

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if lesson.slides[currentIndex].hideHeader != true {
        LessonHeaderCard(slide: lesson.slides[currentIndex])
          .navigationTransition(.zoom(sourceID: lesson.id, in: animation))
      }
      
      Group {
        lesson.slides[currentIndex].content
      }
      .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      .animation(.bouncy, value: currentIndex)
      .frame(maxHeight: .infinity)
      
      Spacer()
      
      HStack {
        Button("Previous") {
          withAnimation(.bouncy) {
            currentIndex = max(currentIndex - 1, 0)
          }
        }
        .buttonStyle(.glassProminent)
        .disabled(currentIndex == 0)
        
        Spacer()
        
        HStack {
          ForEach(lesson.slides.indices, id: \.self) { idx in
            Capsule()
              .fill(idx == currentIndex ? Color.green : Color.gray.opacity(0.5))
              .frame(width: idx == currentIndex ? 40 : 15, height: 15)
              .onTapGesture {
                withAnimation(.bouncy) {
                  currentIndex = idx
                }
              }
          }
        }
        .padding()
        .glassEffect(.clear.interactive(), in: .capsule)
        
        Spacer()
        
        Button("Next") {
          withAnimation(.bouncy) {
            currentIndex = min(currentIndex + 1, lesson.slides.count - 1)
          }
        }
        .buttonStyle(.glassProminent)
        .disabled(currentIndex == lesson.slides.count - 1)
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
    .onPencilSqueeze {phase in
      onClose()
    }
    #endif
  }
}

private struct LessonHeaderCard: View {
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

struct Colours {
  static let Icterine = Color(red: 0.38, green: 0.949, blue: 0.761)
  static let GreenYellow = Color(red: 0.761, green: 0.949, blue: 0.38) // #c2f261
  static let LightGreen = Color(red: 0.569, green: 0.949, blue: 0.569) // #91f291
  static let Aquamarine = Color(red: 0.38, green: 0.949, blue: 0.761) // #61f2c2
  static let FlourescantCyan = Color(red: 0.188, green: 0.949, blue: 0.949) // #30f2f2
}
