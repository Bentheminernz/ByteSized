import SwiftUI
import FoundationModels
import Foundation
import SwiftData
import Confetti

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
  @State var confettiManager: ConfettiManager = .shared
  @State var selectedTab: Tabs = .lessons
  @Environment(\.dismiss) private var dismiss: DismissAction
  
  let model: SystemLanguageModel = SystemLanguageModel.default
  
  enum Tabs: CaseIterable, Hashable {
    case lessons
    case playground
    
    var name: String {
      switch self {
      case .lessons: return "Lessons"
      case .playground: return "Playground"
      }
    }
    
    var icon: String {
      switch self {
      case .lessons: return "book.closed"
      case .playground: return "wand.and.stars.inverse"
      }
    }
    
    @ViewBuilder
    var view: some View {
      switch self {
      case .lessons:
        NavigationStack { MainView() }
      case .playground:
        NavigationStack { PlaygroundView() }
      }
    }
  }
  
  var body: some View {
    VStack {
      switch model.availability {
      case .available:
        TabView(selection: $selectedTab) {
          ForEach(Tabs.allCases, id: \.self) { tab in
            Tab(tab.name, systemImage: tab.icon, value: tab) {
              tab.view
            }
          }
        }
        .adaptiveModal(
          isPresented: Binding(
            get: { !hasSeenWelcome },
            set: { _ in }
          ),
          interactiveDismissDisabled: true
        ) {
          WelcomeView()
        }
      case .unavailable(let unavailableReason):
        AppleIntelligenceUnavailableUI(unavailableReason)
      }
    }
    .adaptiveModal(
      isPresented: Binding(
        get: { hasSeenCompletedAllLessons == false && CompletedLesson.areAllLessonsCompleted(completedLessons: completedLessons) },
        set: { newValue in
          if newValue == false {
            hasSeenCompletedAllLessons = true
          }
        }
      ),
      interactiveDismissDisabled: true
    ) {
      AllLessonsCompleteModal(selectedTab: $selectedTab, hasSeenCompletedAllLessons: $hasSeenCompletedAllLessons)
    }
  }
}
