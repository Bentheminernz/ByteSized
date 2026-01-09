//
//  FoundationModelsService.swift
//  AIEducation
//
//  Created by Ben Lawrence on 05/01/2026.
//

import Foundation
import FoundationModels

enum FoundationModelSession: Hashable {
  /// The shared foundation model session.
  case shared
  
  /// A custom foundation model session identified by a unique string.
  /// Can be used in views where a separate session is needed.
  case custom(_ session: String)
}

typealias FoundationModelsSessionStatus = GenerationState


@MainActor
@Observable
final class FoundationModelsService {
  static let shared = FoundationModelsService()
  
  private var sessions: [FoundationModelSession: LanguageModelSession] = [:]
  private(set) var statuses: [FoundationModelSession: GenerationState] = [:]
  
  private init() {
    sessions[.shared] = LanguageModelSession()
    sessions[.shared]?.prewarm()
    statuses[.shared] = .idle
  }
  
  /// Get the generation status for a specific session
  func status(for session: FoundationModelSession) -> GenerationState {
    return statuses[session] ?? .idle
  }
  
  // TODO: - Add Schema support
  func respond(
    from session: FoundationModelSession = .shared,
    to prompt: String,
    options: GenerationOptions? = nil
  ) async throws -> LanguageModelSession.Response<String> {
    let sessionObj: LanguageModelSession = getSession(for: session)
    
    statuses[session] = .generating
    defer { statuses[session] = .idle }
    
    if let options {
      return try await sessionObj.respond(
        to: prompt,
        options: options
      )
    } else {
      return try await sessionObj.respond(to: prompt)
    }
  }
  
  func streamResponse(
    from session: FoundationModelSession = .shared,
    to prompt: String,
    options: GenerationOptions? = nil
  ) -> LanguageModelSession.ResponseStream<String> {
    let sessionObj: LanguageModelSession = getSession(for: session)
    
    // Set status to generating when stream starts
    statuses[session] = .generating
    
    if let options {
      return sessionObj.streamResponse(
        to: prompt,
        options: options
      )
    } else {
      return sessionObj.streamResponse(to: prompt)
    }
  }
  
  /// Marks a streaming session as complete
  func completeStream(for session: FoundationModelSession) {
    statuses[session] = .idle
  }
  
  /// Get or create a LanguageModelSession for the given context.
  private func getSession(
    for context: FoundationModelSession,
    instructions: String? = nil
  ) -> LanguageModelSession {
    if let existingSession = sessions[context] {
      return existingSession
    }
    
    let newSession = instructions != nil
      ? LanguageModelSession(instructions: instructions!)
      : LanguageModelSession()
    
    sessions[context] = newSession
    statuses[context] = .idle
    return newSession
  }
  
  func createSession(
    for context: FoundationModelSession,
    instructions: String? = nil
  ) {
    let session = getSession(for: context, instructions: instructions)
    session.prewarm()
  }
  
  func createSession(
    for contexts: [FoundationModelSession],
  ) {
    for context in contexts {
      createSession(for: context)
    }
  }
  
  func clearSession(
    for context: FoundationModelSession
  ) {
    sessions.removeValue(forKey: context)
    statuses.removeValue(forKey: context)
  }
  
  func clearSession(
    for contexts: [FoundationModelSession]
  ) {
    for context in contexts {
      clearSession(for: context)
    }
  }
}

