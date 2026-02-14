//
//  GenerationState.swift
//  ByteSized
//
//  Created by Ben Lawrence on 09/12/2025.
//

import SwiftUI

/// State of content generation process
enum GenerationState {
  /// Model is idle, no generation in progress
  case idle

  /// Generation has been requested, preparing to generate
  case requested

  /// Generation is in progress
  case generating

  /// Generation has completed
  case completed

  var modelStatusText: String {
    switch self {
    case .idle: return "Idle"
    case .requested: return "Preparing..."
    case .generating: return "Generating..."
    case .completed: return "Completed"
    }
  }
}
