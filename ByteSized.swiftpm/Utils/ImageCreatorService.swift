//
//  ImageCreatorService.swift
//  ByteSized
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
  
  /// Indicates whether the ImageCreator has been initialized.
  var isInitialized: Bool {
    imageCreator != nil
  }
  
  /// The available styles for image generation.
  var availableStyles: [ImagePlaygroundStyle] {
    if let imageCreator = imageCreator {
      return imageCreator.availableStyles
    } else {
      return []
    }
  }
  
  /// The current state of image generation.
  var generationState: GenerationState = .idle
  
  /// Indicates whether the ImageCreator is supported on this device.
  var isSupported: Bool?

  private init() {
    Task {
      await initialize()
    }
  }

  private func initialize() async {
    do {
      imageCreator = try await ImageCreator()
      isSupported = true
    } catch let error as ImageCreator.Error {
      print("Error initializing ImageCreator: \(error)")
      if error == .notSupported {
        isSupported = false
      }
    } catch {
      print("Unexpected error initializing ImageCreator: \(error)")
    }
  }

  /// Generates images based on the provided prompts and style.
  /// - Parameters:
  ///   - prompts: An array of `ImagePlaygroundConcept` prompts.
  ///   - style: The style to apply to the generated images.
  ///   - limit: The maximum number of images to generate.
  /// - Returns: An asynchronous sequence of created images.
  func generateImages(
    for prompts: [ImagePlaygroundConcept],
    style: ImagePlaygroundStyle,
    limit: Int
  ) async throws -> any AsyncSequence<ImageCreator.CreatedImage, Error> {
    guard let imageCreator = imageCreator else {
      print("ImageCreator not initialized")
      throw NSError(
        domain: "ImageCreatorService",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "ImageCreator not initialized"]
      )
    }

    generationState = .generating
    let images = imageCreator.images(for: prompts, style: style, limit: limit)
    generationState = .idle
    return images
  }
}

