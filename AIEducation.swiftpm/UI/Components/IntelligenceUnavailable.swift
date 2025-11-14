//
//  IntelligenceUnavailable.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import SwiftUI
import FoundationModels

@ViewBuilder
func AppleIntelligenceUnavailableUI(_ reason: SystemLanguageModel.Availability.UnavailableReason) -> some View {
  switch reason {
  case .deviceNotEligible:
    ContentUnavailableView {
      Label("Apple Intelligence Unavailable", systemImage: "apple.intelligence.badge.xmark")
    } description: {
      Text("Your device is not eligible to use Apple Intelligence features.")
    }
  case .appleIntelligenceNotEnabled:
    ContentUnavailableView {
      Label("Apple Intelligence Not Enabled", systemImage: "apple.intelligence.badge.xmark")
    } description: {
      Text("Please enable Apple Intelligence in Settings to use these features.")
    }
  case .modelNotReady:
    ContentUnavailableView {
      Label("Apple Intelligence Not Ready", systemImage: "apple.intelligence.badge.xmark")
    } description: {
      Text("Apple Intelligence is not ready yet. Please try again later.")
    }
  default:
    ContentUnavailableView {
      Label("Apple Intelligence Unavailable", systemImage: "apple.intelligence.badge.xmark")
    } description: {
      Text("Apple Intelligence features are currently unavailable.")
    }
  }
}
