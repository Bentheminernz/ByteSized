//
//  ImageCreatorService.swift
//  AIEducation
//
//  Created by Ben Lawrence on 05/01/2026.
//

import Foundation
import ImagePlayground

@MainActor
@Observable
final class ImageCreatorService {
  static let shared = ImageCreatorService()
  
  private var imageCreator: ImageCreator?
  var isInitialized: Bool {
    imageCreator != nil
  }
  
  private init() {
    Task {
      await initialize()
    }
  }
  
  private func initialize() async {
    do {
      imageCreator = try await ImageCreator()
    } catch {
      print("Error initializing ImageCreator: \(error)")
    }
  }
  
  func generateImages(
    for prompts: [ImagePlaygroundConcept],
    style: ImagePlaygroundStyle,
    limit: Int
  ) async throws -> any AsyncSequence<ImageCreator.CreatedImage, Error> {
    guard let imageCreator = imageCreator else {
      throw NSError(
        domain: "ImageCreatorService",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "ImageCreator is not initialized."]
      )
    }
    
    return imageCreator.images(for: prompts, style: style, limit: limit)
  }
}
