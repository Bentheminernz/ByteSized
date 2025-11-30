//
//  ConfettiManager.swift
//  AIEducation
//
//  Created by Ben Lawrence on 30/11/2025.
//

import Foundation
import Observation
import SwiftUI
import Confetti

@MainActor
@Observable
class ConfettiManager {
  static let shared = ConfettiManager()
  
  var isShowingConfetti: Bool = false
  var emissionDuration: Double = 3.0
  var confettiAmount: Int = 3
  var displayDuration: Double = 10.0
  
  private init () {}
  
  func start(emissionDuration: Double = 3.0, confettiAmount: Int = 3, displayDuration: Double = 10.0) {
    self.emissionDuration = emissionDuration
    self.confettiAmount = confettiAmount
    self.displayDuration = displayDuration
    self.isShowingConfetti = true
    
    Task {
      try? await Task.sleep(nanoseconds: UInt64(displayDuration * 1_000_000_000))
      self.isShowingConfetti = false
    }
  }
  
  func stop() {
    self.isShowingConfetti = false
  }
}

struct ConfettiModifier: ViewModifier {
  @State private var manager = ConfettiManager.shared
  
  func body(content: Content) -> some View {
    content
      .overlay(
        ZStack {
          if manager.isShowingConfetti {
            ForEach(0..<manager.confettiAmount, id: \.self) { _ in
              ConfettiView(emissionDuration: manager.emissionDuration)
            }
          }
        }
        .allowsHitTesting(false)
      )
  }
}

extension View {
  func confettiOverlay() -> some View {
    self.modifier(ConfettiModifier())
  }
}
