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
  
  private init() {
    sessions[.shared] = LanguageModelSession()
    sessions[.shared]?.prewarm()
  }
  
  // TODO: - Add Schema support
  func respond(
    from session: FoundationModelSession = .shared,
    to prompt: String,
    options: GenerationOptions? = nil
  ) async throws -> LanguageModelSession.Response<String> {
    let session: LanguageModelSession = getSession(for: session)
    
    if let options {
      return try await session.respond(
        to: prompt,
        options: options
      )
    } else {
      return try await session.respond(to: prompt)
    }
  }
  
  func streamResponse(
    from session: FoundationModelSession = .shared,
    to prompt: String,
    options: GenerationOptions? = nil
  ) -> LanguageModelSession.ResponseStream<String> {
    let session: LanguageModelSession = getSession(for: session)
    
    if let options {
      return session.streamResponse(
        to: prompt,
        options: options
      )
    } else {
      return session.streamResponse(to: prompt)
    }
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
    return newSession
  }
  
  func createSession(
    for context: FoundationModelSession,
    instructions: String? = nil
  ) {
    let session = getSession(for: context, instructions: instructions)
    session.prewarm()
  }
  
  func clearSession(for context: FoundationModelSession) {
    sessions.removeValue(forKey: context)
  }
}
