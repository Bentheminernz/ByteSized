import SwiftUI
import FoundationModels

@main
struct MyApp: App {
  @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
  
  let model: SystemLanguageModel = SystemLanguageModel.default
  
  var body: some Scene {
    WindowGroup {
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
          .fullScreenCover(
            isPresented: Binding(
              get: { !hasSeenWelcome },
              set: { _ in }
            )
          ) {
            Welcome()
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
    }
  }
}

