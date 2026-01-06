import SwiftUI
import FoundationModels
import Foundation
import SwiftData
import Confetti

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
  @AppStorage("hasSeenCompletedAllLessons") var hasSeenCompletedAllLessons: Bool = false
  @Query private var completedLessons: [CompletedLesson]
  @State var confettiManager: ConfettiManager = .shared
  @State var selectedTab: Tabs = .lessons
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  @State private var showiPhoneWarning: Bool = false
  
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
  
  #if DEBUG
  @State var showDebugMenu: Bool = false
  #endif
  
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
          
          Button("Exit") {
            exit(0)
          }
          
          Button("hasSeenWelcome: \(hasSeenWelcome.description)") {
            hasSeenWelcome.toggle()
          }
          
          Button("hasSeenCompletedAllLessons: \(hasSeenCompletedAllLessons.description)") {
            hasSeenCompletedAllLessons.toggle()
          }
        }
        .padding()
        .glassEffect(.regular.tint(.black.opacity(0.5)), in: .rect(cornerRadius: 12))
      }
    }
    #endif
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
    .adaptiveModal(
      isPresented: $showiPhoneWarning,
      interactiveDismissDisabled: true
    ) {
      VStack {
        WelcomeComponents.WelcomePageHeader(title: "iPhone Warning", subtitle: "Limited Functionality", imageName: "exclamationmark.triangle.fill", imageColor: .yellow)
        Text("AIEducation is best experienced on an iPad due to its larger screen size and enhanced capabilities. Some features may be limited or not function optimally on an iPhone.")
        
        Spacer()
        
        Button(action: {
          showiPhoneWarning = false
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
      if horizontalSizeClass == .compact {
        showiPhoneWarning = true
      }
    }
    .onChange(of: horizontalSizeClass) {
      if horizontalSizeClass == .compact {
        showiPhoneWarning = true
      }
    }
  }
}
