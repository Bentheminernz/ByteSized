//
//  04-GuidedGeneration.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: WIP

import FoundationModels
import SwiftUI

@Generable
struct PlayerCharacter {
  @Guide(description: "A funky name for the character")
  var name: String

  var age: Int

  @Guide(description: "A list of personality traits", .count(4))
  var personalityTraits: [String]
}

struct GuidedGeneration1: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  @State var character: PlayerCharacter.PartiallyGenerated?
  let session: FoundationModelSession = .shared

  var body: some View {
    VStack {
      if let character = character {
        if let name = character.name {
          Text("Character Name: \(name)")
        }

        if let age = character.age {
          Text("Character Age: \(age)")
        }

        if let traits = character.personalityTraits {
          Text("Personality Traits:")
          ForEach(traits, id: \.self) { trait in
            Text("- \(trait)")
          }
        }
      }
    }
    .task {
      do {
        try await generateCharacter()
      } catch {
        print("Error generating character: \(error)")
      }
    }
  }

  func generateCharacter() async throws {
    let response = foundationModelsService.streamResponse(
      from: session,
      generating: PlayerCharacter.self,
    ) {
      "The character is a wise old wizard."
    }

    for try await partial in response {
      withAnimation(.bouncy) {
        character = partial.content
      }
    }
  }
}
