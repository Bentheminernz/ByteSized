import SwiftUI
import FoundationModels

@main
struct MyApp: App {
  let model: SystemLanguageModel = SystemLanguageModel.default
  
  var body: some Scene {
    WindowGroup {
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
      case .unavailable(let unavailableReason):
        AppleIntelligenceUnavailableUI(unavailableReason)
      }
    }
  }
}

