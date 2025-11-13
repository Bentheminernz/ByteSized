//
//  MainView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI

struct MainView: View {
  @Namespace private var animation
  @State private var selectedLesson: Lesson?
  
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
                  Button {
                    selectedLesson = lesson
                  } label: {
                    LessonCard(lesson)
                      .frame(width: 400, height: 120, alignment: .leading)
                  }
                  .buttonStyle(.plain)
                  .matchedTransitionSource(id: lesson.id, in: animation)
                  .scrollTransition { content, phase in
                    content
                      .opacity(phase.isIdentity ? 1 : 0)
                      .scaleEffect(phase.isIdentity ? 1 : 0.8)
                      .blur(radius: phase.isIdentity ? 0 : 10)
                  }
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
  private func LessonCard(_ lesson: Lesson) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "\(lesson.icon, default: "book")")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .foregroundColor(.accentColor)
          .symbolColorRenderingMode(.gradient)
        
        VStack(alignment: .leading) {
          Text(lesson.title)
            .font(.headline)
            .padding(.bottom, 2)
          Text(lesson.description)
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
      
      lesson.view
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
  let id: Int
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
  @Environment(\.colorScheme) private var colorScheme
  let title: String
  let onClose: () -> Void

  var body: some View {
    ZStack {
      Rectangle()
        .fill(colorScheme == .light ? .gray.opacity(0.1) : .black)
        .ignoresSafeArea(edges: .top)
        .frame(height: 56)

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
