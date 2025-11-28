import SwiftUI
import FoundationModels
import Foundation
import SwiftData

@main
struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      RootView()
    }
    .modelContainer(for: [CompletedLesson.self])
  }
}


struct RootView: View {
  @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
  @AppStorage("hasSeenCompletedAllLessons") var hasSeenCompletedAllLessons: Bool = false
  @Query private var completedLessons: [CompletedLesson]
  
  let model: SystemLanguageModel = SystemLanguageModel.default
  
  var body: some View {
    VStack {
      switch model.availability {
      case .available:
        TabView {
          Tab("Lessons", systemImage: "book.closed") {
            NavigationStack {
              MainView()
            }
          }
          
          if areAllLessonsCompleted() {
            Tab("Playground", systemImage: "wand.and.stars.inverse") {
              NavigationStack {
                PlaygroundView()
                  .navigationTitle("Playground")
              }
            }
          }
        }
        .adaptiveModal(
          isPresented: Binding(
            get: { !hasSeenWelcome },
            set: { _ in }
          ), interactiveDismissDisabled: true
        ) {
          WelcomeView()
        }
      case .unavailable(let unavailableReason):
        AppleIntelligenceUnavailableUI(unavailableReason)
      }
    }
    #if DEBUG
    .onPencilDoubleTap { _ in
      exit(0)
    }
    #endif
    .adaptiveModal(isPresented: Binding(
      get: { hasSeenCompletedAllLessons == false && areAllLessonsCompleted() },
      set: { newValue in
        if newValue == false {
          hasSeenCompletedAllLessons = true
        }
      }
    ),interactiveDismissDisabled: true) {
      VStack {
        Text("Yyay")
      }
    }
  }
  
  func areAllLessonsCompleted() -> Bool {
    let allLessonIDs = LessonCourses.allCourses.flatMap { course in
      course.lessons.map { $0.id }
    }
    
    let completedLessonIDs = Set(completedLessons.map { $0.lessonID })
    
    return allLessonIDs.allSatisfy { completedLessonIDs.contains($0) }
  }
}
