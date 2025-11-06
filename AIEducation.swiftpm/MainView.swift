//
//  MainView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI

struct Lesson: Identifiable, Equatable {
  let id: String
  let title: String
  let description: String
}

struct MainView: View {
  @Namespace private var animation
  @State private var selectedLesson: Lesson?

  let grid = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: grid, spacing: 20) {
        ForEach(1...12, id: \.self) { index in
          let lesson = Lesson(
            id: "lesson_\(index)",
            title: "Lorem \(index)",
            description: "Description for lorem \(index)."
          )
          Button {
            selectedLesson = lesson
          } label: {
            LessonCard(id: lesson.id, title: lesson.title, description: lesson.description)
          }
          .buttonStyle(.plain)
          .matchedTransitionSource(id: lesson.id, in: animation)
          .scrollTransition { content, phase in
            content
              .opacity(phase.isIdentity ? 1 : 0)
              .scaleEffect(phase.isIdentity ? 1 : 0.5)
              .blur(radius: phase.isIdentity ? 0 : 10)
          }
        }
      }
      .padding()
    }
    .navigationTitle("Lorem")
    .background(
      LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .fullScreenCover(item: $selectedLesson) { lesson in
      LessonSheet(lesson: lesson, animation: animation, onClose: { selectedLesson = nil })
    }
  }
  
  @ViewBuilder
  private func LessonCard(id: String, title: String, description: String) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "star")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .foregroundColor(.accentColor)
          .symbolColorRenderingMode(.gradient)
        
        VStack(alignment: .leading) {
          Text(title)
            .font(.headline)
            .padding(.bottom, 2)
          Text(description)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      Spacer()
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
  }
}

struct LessonSheet: View {
  let lesson: Lesson
  let animation: Namespace.ID
  let onClose: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      LessonHeaderCard(id: lesson.id, title: lesson.title)
        .navigationTransition(.zoom(sourceID: lesson.id, in: animation))
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
    .safeAreaInset(edge: .top) {
      FakeNavBar(title: lesson.title, onClose: onClose)
    }
  }
}

private struct LessonHeaderCard: View {
  let id: String
  let title: String

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "sparkles")
        .resizable()
        .scaledToFit()
        .frame(width: 48, height: 48)
        .foregroundColor(.accentColor)
        .symbolColorRenderingMode(.gradient)
      Text(title)
        .font(.title2).bold()
      Spacer()
    }
    .padding()
    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 15))
  }
}

private struct FakeNavBar: View {
  let title: String
  let onClose: () -> Void

  var body: some View {
    ZStack {
      Rectangle()
        .fill(.black)
        .ignoresSafeArea(edges: .top)
        .frame(height: 56)
//        .overlay(
//          Rectangle()
//            .fill(Color.primary.opacity(0.08))
//            .frame(height: 0.5)
//            .frame(maxHeight: .infinity, alignment: .bottom), alignment: .bottom
//        )

      HStack {
        Spacer().frame(width: 44)

        Text(title)
          .font(.headline)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(maxWidth: .infinity)

        Button(action: onClose) {
          Text("Done")
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Close")
      }
      .padding(.horizontal, 12)
      .frame(height: 56)
    }
  }
}

