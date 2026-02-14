//
//  AllLessonsComplete.swift
//  ByteSized
//
//  Created by Ben Lawrence on 06/12/2025.
//

import Confetti
import SwiftUI

struct AllLessonsCompleteModal: View {
  @Binding var selectedTab: RootView.Tabs
  @Binding var hasSeenCompletedAllLessons: Bool
  @State var confettiManager: ConfettiManager = .shared
  @Environment(\.dismiss) private var dismiss: DismissAction

  var body: some View {
    VStack {
      WelcomeComponents.WelcomePageHeader(
        title: "Congratulations!",
        subtitle: "You've completed all labs.",
        symbolName: "trophy.fill",
        symbolBackgroundColor: .yellow
      )

      Text(
        "Since you've completed all the labs, you now have access to the Playground where you can experiment with prompts, parameters and guided generation!"
      )

      Spacer()

      Button(action: {
        selectedTab = .playground
        hasSeenCompletedAllLessons = true
        dismiss()
      }) {
        Text("Take me there!!")
          .font(.headline)
          .padding()
      }
      .buttonStyle(.glassProminent)
      .buttonSizing(.flexible)
      .padding(.bottom)

      Button("Maybe later") {
        hasSeenCompletedAllLessons = true
        dismiss()
      }
      .padding(.bottom)
    }
    .padding()
    .onAppear {
      confettiManager.start(displayDuration: 10)
    }
    .confettiOverlay(
      isPresented: Binding(
        get: { confettiManager.isShowingConfetti },
        set: { newValue in
          if newValue == false {
            confettiManager.stop()
          }
        }
      )
    ) {
      ConfettiView(emissionDuration: confettiManager.emissionDuration)
    }
  }
}
