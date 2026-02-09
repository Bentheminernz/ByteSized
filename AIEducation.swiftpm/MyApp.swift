import Confetti
import Foundation
import FoundationModels
import SwiftData
import SwiftUI

@main
struct MyApp: App {
  @State private var confettiManager: ConfettiManager = .shared
  @State private var imageCreatorService: ImageCreatorService = .shared
  @State private var foundationModelsService: FoundationModelsService = .shared

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(confettiManager)
        .environment(imageCreatorService)
        .environment(foundationModelsService)
    }
    .modelContainer(for: [CompletedLesson.self])
  }
}

struct RootView: View {
  @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
  @AppStorage("hasSeenCompletedAllLessons") var hasSeenCompletedAllLessons:
    Bool = false
  @Query private var completedLessons: [CompletedLesson]
  @State var confettiManager: ConfettiManager = .shared
  @State var selectedTab: Tabs = .lessons

  @Environment(\.dismiss) private var dismiss
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @State private var showSmallScreenWarning: Bool = false

  let model: SystemLanguageModel = SystemLanguageModel.default

  enum Tabs: CaseIterable, Hashable {
    case lessons
    case playground
    #if DEBUG
      case schema
    #endif

    var name: String {
      switch self {
      case .lessons: return "Lessons"
      case .playground: return "Playground"
      #if DEBUG
        case .schema: return "Schema"
      #endif
      }
    }

    var icon: String {
      switch self {
      case .lessons: return "book.closed"
      case .playground: return "wand.and.stars.inverse"
      #if DEBUG
        case .schema: return "puzzlepiece.extension"
      #endif
      }
    }

    @MainActor
    @ViewBuilder
    var view: some View {
      switch self {
      case .lessons:
        NavigationStack { MainView() }
      case .playground:
        NavigationStack { PlaygroundView() }
      #if DEBUG
        case .schema:
          NavigationStack { SchemaBuilderView() }
      #endif
      }
    }
  }

  #if DEBUG
    @State var showDebugMenu: Bool = false
  @Environment(FoundationModelsService.self) private var foundationModelsService
  #endif

  var body: some View {
    VStack {
      switch model.availability {
      case .available:
        TabView(selection: $selectedTab) {
//          ForEach(Tabs.allCases, id: \.self) { tab in
          ForEach(Tabs.allCases.filter { $0.name != "Schema" }, id: \.self) { tab in
            Tab(tab.name, systemImage: tab.icon, value: tab) {
              tab.view
            }
          }
        }
        .adaptiveModal(
          isPresented: Binding(
            get: { !hasSeenWelcome },
             set: { hasSeenWelcome = !$0 }
          ),
          interactiveDismissDisabled: true
        ) {
          WelcomeView()
        }
      case .unavailable(let unavailableReason):
        AppleIntelligenceUnavailableUI(reason: unavailableReason)
      }
    }
    #if DEBUG
      .onPencilDoubleTap { _ in
        showDebugMenu.toggle()
      }
      .overlay {
        if showDebugMenu {
          VStack {
            Button("Close Debug Menu") {
              showDebugMenu = false
            }
            
            Button("Dismiss Current Screen") {
              dismiss()
            }

            Button("Exit") {
              exit(0)
            }

            Button("hasSeenWelcome: \(hasSeenWelcome.description)") {
              hasSeenWelcome.toggle()
            }

            Button(
              "hasSeenCompletedAllLessons: \(hasSeenCompletedAllLessons.description)"
            ) {
              hasSeenCompletedAllLessons.toggle()
            }
            
            Button("Print active llms") {
              print(foundationModelsService.printActiveSessions())
            }
          }
          .padding()
          .glassEffect(
            .regular.tint(.black.opacity(0.5)),
            in: .rect(cornerRadius: 12)
          )
        }
      }
    #endif
    .adaptiveModal(
      isPresented: Binding(
        get: {
          hasSeenCompletedAllLessons == false
            && CompletedLesson.areAllLessonsCompleted(
              completedLessons: completedLessons
            )
        },
        set: { newValue in
          if newValue == false {
            hasSeenCompletedAllLessons = true
          }
        }
      ),
      interactiveDismissDisabled: true
    ) {
      AllLessonsCompleteModal(
        selectedTab: $selectedTab,
        hasSeenCompletedAllLessons: $hasSeenCompletedAllLessons
      )
    }
    .adaptiveModal(
      isPresented: $showSmallScreenWarning,
      interactiveDismissDisabled: true
    ) {
      VStack {
        WelcomeComponents.WelcomePageHeader(
          title: "Small Screen Warning",
          subtitle: "Limited Functionality",
          symbolName: "exclamationmark.triangle.fill",
          symbolBackgroundColor: .yellow
        )
        Text(
          "ByteSized is best experienced in full screen. On smaller windows, some features may not work properly. We recommend using ByteSized in full screen for the best experience!"
        )

        Spacer()

        Button(action: {
          showSmallScreenWarning = false
        }) {
          Text("Understood")
            .font(.headline)
            .padding()
        }
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
      }
      .padding()
    }
    .onAppear {
      if horizontalSizeClass == .compact && hasSeenWelcome {
        showSmallScreenWarning = true
      }
    }
    .onChange(of: horizontalSizeClass) {
      if horizontalSizeClass == .compact && hasSeenWelcome {
        showSmallScreenWarning = true
      }
    }
    .onChange(of: hasSeenWelcome) {
      if hasSeenWelcome && horizontalSizeClass == .compact {
        showSmallScreenWarning = true
      }
    }
  }
}
