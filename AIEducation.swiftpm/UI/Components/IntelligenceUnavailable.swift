//
//  IntelligenceUnavailable.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import FoundationModels
import SwiftUI

struct AppleIntelligenceUnavailableUI: View {
  let reason: SystemLanguageModel.Availability.UnavailableReason
  
  private var title: String {
    reasonContent(for: reason).0
  }

  private var message: String {
    reasonContent(for: reason).1
  }
  
  var body: some View {
    ContentUnavailableView {
      Label(title, systemImage: "apple.intelligence.badge.xmark")
    } description: {
      Text(message)
    } actions: {
      if reason == .appleIntelligenceNotEnabled {
        Button("Open Settings") {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        }
      }
    }
  }
  
  
  private func reasonContent(
    for reason: SystemLanguageModel.Availability.UnavailableReason
  ) -> (String, String) {
    switch reason {
    case .deviceNotEligible:
      return ("Apple Intelligence Unavailable",
              "Your device is not eligible to use Apple Intelligence features.")
    case .appleIntelligenceNotEnabled:
      return ("Apple Intelligence Not Enabled",
              "Please enable Apple Intelligence in Settings to use these features.")
    case .modelNotReady:
      return ("Apple Intelligence Not Ready",
              "Apple Intelligence is not ready yet. Please try again later.")
    default:
      return ("Apple Intelligence Unavailable",
              "Apple Intelligence features are currently unavailable.")
    }
  }
}
