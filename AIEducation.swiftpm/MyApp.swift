import SwiftUI
import FoundationModels
import Foundation
import SwiftData

@main
struct MyApp: App {
  @State var confettiManager: ConfettiManager = .shared
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(confettiManager)
        .onPencilDoubleTap { _ in
          confettiManager.start(displayDuration: 10)
        }
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
          
          Tab("Playground", systemImage: "wand.and.stars.inverse") {
            NavigationStack {
              PlaygroundView()
                .navigationTitle("Playground")
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
//    #if DEBUG
//    .onPencilDoubleTap { _ in
//      exit(0)
//    }
//    #endif
    .adaptiveModal(isPresented: Binding(
      get: { hasSeenCompletedAllLessons == false && CompletedLesson.areAllLessonsCompleted(completedLessons: completedLessons) },
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
//    .confettiOverlay() MARK: Reevaluate
  }
}
