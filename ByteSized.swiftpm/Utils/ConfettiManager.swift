//
//  ConfettiManager.swift
//  AIEducation
//
//  Created by Ben Lawrence on 30/11/2025.
//

import Confetti
import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
class ConfettiManager {
  static let shared = ConfettiManager()

  var isShowingConfetti: Bool = false
  var emissionDuration: Double = 3.0
  var confettiAmount: Int = 3
  var displayDuration: Double = 10.0

  private init() {}

  func start(
    emissionDuration: Double = 3.0,
    confettiAmount: Int = 3,
    displayDuration: Double = 10.0
  ) {
    self.emissionDuration = emissionDuration
    self.confettiAmount = confettiAmount
    self.displayDuration = displayDuration
    self.isShowingConfetti = true

    Task {
      try? await Task.sleep(
        nanoseconds: UInt64(displayDuration * 1_000_000_000)
      )
      self.isShowingConfetti = false
    }
  }

  func stop() {
    self.isShowingConfetti = false
  }
}

private struct ConfettiOverlayModifier<Confetti: View>: ViewModifier {
  @Binding var isPresented: Bool
  let confetti: () -> Confetti

  func body(content: Content) -> some View {
    ZStack {
      content
      if isPresented {
        confetti()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()
          .allowsHitTesting(false)
          .transition(.opacity)
      }
    }
  }
}

extension View {
  public func confettiOverlay(
    isPresented: Binding<Bool>,
    @ViewBuilder confetti: @escaping () -> some View
  ) -> some View {
    modifier(
      ConfettiOverlayModifier(isPresented: isPresented, confetti: confetti)
    )
  }
}
