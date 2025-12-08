//
//  AllLessonsComplete.swift
//  AIEducation
//
//  Created by Ben Lawrence on 06/12/2025.
//

import SwiftUI
import Confetti

struct AllLessonsCompleteModal: View {
  @Binding var selectedTab: RootView.Tabs
  @Binding var hasSeenCompletedAllLessons: Bool
  @State var confettiManager: ConfettiManager = .shared
  @Environment(\.dismiss) private var dismiss: DismissAction
  
  var body: some View {
    VStack {
      WelcomeComponents.WelcomePageHeader(title: "Congratulations!", subtitle: "You've completed all lessons.", imageName: "trophy.fill", imageColor: .yellow)
      
      Text("Since you've completed all the lessons, you now have access to the AI Playground where you can experiment with prompts and parameters!")
      
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
