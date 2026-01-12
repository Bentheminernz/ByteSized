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

  /// Produces a generated response as a string.
  /// - Parameters:
  ///   - session: The foundation model session to use.
  ///   - options: Optional generation options to customize the response.
  ///   - prompt: A PromptBuilder closure providing the prompt content.
  /// - Returns: A response containing the generated string.
  func respond(
    from session: FoundationModelSession = .shared,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder _ prompt: @escaping () throws -> Prompt
  ) async throws -> LanguageModelSession.Response<String> {
    let sessionObj: LanguageModelSession = getSession(for: session)

    statuses[session] = .generating
    defer { statuses[session] = .idle }

    return try await sessionObj.respond(
      options: options,
      prompt: prompt,
    )
  }

  /// Produces a generated typed response for any Generable content type.
  /// - Parameters:
  ///   - session: The foundation model session to use.
  ///   - type: The Generable type to generate.
  ///   - includeSchemaInPrompt: Whether to include the schema in the prompt.
  ///   - options: Generation options to customize the response.
  ///   - prompt: A PromptBuilder closure providing the prompt content.
  /// - Returns: A typed response containing the generated content.
  func respond<Content: Generable>(
    from session: FoundationModelSession = .shared,
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder _ prompt: @escaping () throws -> Prompt
  ) async throws -> LanguageModelSession.Response<Content> {
    let sessionObj: LanguageModelSession = getSession(for: session)

    statuses[session] = .generating
    defer { statuses[session] = .idle }

    return try await sessionObj.respond(
      generating: type,
      includeSchemaInPrompt: includeSchemaInPrompt,
      options: options,
      prompt: prompt
    )
  }

  /// Produces a generated typed response for a GenerationSchema content type.
  /// - Parameters:
  ///   - session: The foundation model session to use.
  ///   - schema: The GenerationSchema type to generate.
  ///   - options: Generation options to customize the response.
  ///   - prompt: A PromptBuilder closure providing the prompt content.
  /// - Returns: A typed response containing the generated content.
  func respond(
    from session: FoundationModelSession = .shared,
    generating schema: GenerationSchema,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder _ prompt: @escaping () throws -> Prompt
  ) async throws -> LanguageModelSession.Response<GeneratedContent> {
    let sessionObj: LanguageModelSession = getSession(for: session)

    statuses[session] = .generating
    defer { statuses[session] = .idle }

    return try await sessionObj.respond(
      schema: schema,
      includeSchemaInPrompt: includeSchemaInPrompt,
      options: options,
      prompt: prompt
    )
  }

  /// Streams a generated response as a string.
  /// - Parameters:
  ///   - session: The foundation model session to use.
  ///   - prompt: The input prompt for the language model.
  ///   - options: Optional generation options to customize the response.
  /// - Returns: A response stream producing the generated string in chunks.
  func streamResponse(
    from session: FoundationModelSession = .shared,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder _ prompt: @escaping () -> Prompt
  ) -> LanguageModelSession.ResponseStream<String> {
    let sessionObj: LanguageModelSession = getSession(for: session)

    statuses[session] = .generating

    return sessionObj.streamResponse(
      options: options,
      prompt: prompt
    )
  }

  /// Streams a generated typed response for any Generable content type.
  /// - Parameters:
  ///   - session: The foundation model session to use.
  ///   - type: The Generable type to generate.
  ///   - includeSchemaInPrompt: Whether to include the schema in the prompt.
  ///   - options: Generation options to customize the response.
  ///   - prompt: A PromptBuilder closure providing the prompt content.
  /// - Returns: A typed response stream producing the generated content in chunks.
  func streamResponse<Content: Generable>(
    from session: FoundationModelSession = .shared,
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder _ prompt: @escaping () -> Prompt
  ) -> LanguageModelSession.ResponseStream<Content> {
    let sessionObj: LanguageModelSession = getSession(for: session)

    statuses[session] = .generating

    return sessionObj.streamResponse(
      generating: type,
      includeSchemaInPrompt: includeSchemaInPrompt,
      options: options,
      prompt: prompt
    )
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

    let newSession =
      instructions != nil
      ? LanguageModelSession(instructions: instructions!)
      : LanguageModelSession()

    sessions[context] = newSession
    statuses[context] = .idle
    return newSession
  }

  /// Resets the context of a session by creating a new one.
  func resetContext(for session: FoundationModelSession) {
    clearSession(for: session)
    _ = getSession(for: session)
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
