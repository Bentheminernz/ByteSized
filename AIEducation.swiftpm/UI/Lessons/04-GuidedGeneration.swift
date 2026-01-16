//
//  04-GuidedGeneration.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: WIP

import FoundationModels
import SwiftUI

struct GuidedGeneration1: View {
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Text("Large Language Models generate human-like text by design.")
          .font(.title.bold())
        Text(
          """
             While perfect for chatbots or content creation, this becomes liability when you need to parse or integrate outputs
             programmatically. Unstructured text responses require brittle parsing logic that breaks easily. Structured outputs solve
             this by constraining the model to return predictable predefined formats, making them as reliable as any API call.
          """
        )
      }
      Spacer()
    }
  }
}

struct GuidedGeneration2: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService

  let sessionPlainText: FoundationModelSession = .custom(
    "GuidedGenerationPlainText"
  )
  let sessionStructured: FoundationModelSession = .custom(
    "GuidedGenerationStructured"
  )

  @State var plainTextSuperhero: String = ""
  @State var structuredSuperhero: Superhero.PartiallyGenerated? = nil

  @Generable
  struct Superhero {
    @Guide(description: "The superhero's name")
    var name: String

    @Guide(description: "The superhero's primary superpower")
    var superpower: String

    var age: Int

    @Guide(
      description: "Whether the character is heroic or character villainous"
    )
    var isHeroic: Bool

    @Guide(description: "A list of the superhero's allies", .count(2...4))
    var allies: [String]
  }

  var body: some View {
    VStack(spacing: 24) {
      Text("For example..")
        .font(.title.bold())
      
      Text("If you wanted to get an LLM to generate you a superhero, it would return something like this:")
        .foregroundStyle(.secondary)
      
      if !plainTextSuperhero.isEmpty {
        Text(plainTextSuperhero)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .glassEffect(in: .rect(cornerRadius: 10))
      }
      
      VStack(spacing: 12) {
        Text("This output is easy to read as a human, but is near impossible to work with programmatically! You'd have to use some brittle parsing logic to extract the relevant fields, which is not a good practice")
          .foregroundStyle(.secondary)
        
        Text("Instead, by guiding the model to return structured data, you can get reliable, predictable outputs that are easy to work with:")
          .foregroundStyle(.secondary)
      }
      
      if let superhero = structuredSuperhero {
        VStack(alignment: .leading, spacing: 12) {
          if let name = superhero.name {
            HStack {
              Text("Name:")
                .fontWeight(.semibold)
              Text(name)
            }
          }
          
          if let superpower = superhero.superpower {
            HStack {
              Text("Superpower:")
                .fontWeight(.semibold)
              Text(superpower)
            }
          }
          
          if let age = superhero.age {
            HStack {
              Text("Age:")
                .fontWeight(.semibold)
              Text("\(age)")
            }
          }
          
          if let isHeroic = superhero.isHeroic {
            HStack {
              Text("Alignment:")
                .fontWeight(.semibold)
              Text(isHeroic ? "Heroic" : "Villainous")
            }
          }
          
          if let allies = superhero.allies, !allies.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
              Text("Allies:")
                .fontWeight(.semibold)
              Text(allies.joined(separator: ", "))
            }
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 10))
      }
    }
    .padding()
    .onAppear {
      foundationModelsService.createSession(for: [
        sessionPlainText, sessionStructured,
      ])

      Task {
        do {
          let response = foundationModelsService.streamResponse(
            from: sessionPlainText,
          ) {
            "Create me a unique superhero character with a name, superpower, age, alignment (heroic or villainous), and a list of 2-4 allies. Return in sentence form, not a list or JSON."
          }
          for try await content in response {
            withAnimation(.bouncy) {
              plainTextSuperhero = content.content
            }
          }

          let responseStruct = foundationModelsService.streamResponse(
            from: sessionStructured,
            generating: Superhero.self
          ) {
            "Generate me a super awesome superhero!"
          }

          for try await content in responseStruct {
            withAnimation(.bouncy) {
              structuredSuperhero = content.content
            }
          }
        } catch {
          print("Error generating plain text superhero: \(error)")
        }
      }
    }
  }
}

struct GuidedGeneration3: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService

  let generableStruct = """
    import FoundationModels

    @Generable
    struct Superhero {
      @Guide(description: "The superhero's name")
      var name: String

      var age: Int

      @Guide(description: "The superhero's primary superpower")
      var superpower: String

      @Guide(description: "Whether the character is heroic or character villainous")
      var isHeroic: Bool

      @Guide(description: "A list of the superhero's allies", .count(2...4))
      var allies: [String]
    }
    """
  
  let callingModel = #"""
    import FoundationModels
    
    // Create a language model session
    let session = LanguageModelSession()
    
    // Generate a structured Superhero object
    let response = try await session.respond(
      generating: Superhero.self
    ) {
      "Generate me a super awesome superhero!"
    }
    
    // Prints the whole generated Superhero struct
    print("Generated Superhero: \(response.content)")
    
    // Print individual fields
    print("Name: \(response.content.name)")
    """#

  var body: some View {
    HStack {
      ScrollView {
        VStack {
          Text("Defining a Structured Output")
            .font(.title.bold())
          
          Text(
              "Using the Apple Foundation Models framework it is incredibly easy to define structured outputs for the on-device LLM to generate. You simply define a Swift struct with the \(Text("@Generable").monospaced()) attribute and annotate any fields you want to guide the model on using the \(Text("@Guide").monospaced()) attribute."
          )
          .padding(.vertical, 4)
          .padding(.horizontal)
          
          CodeViewer(code: generableStruct, language: "swift")
        }
      }
      
      Divider()
      
      ScrollView {
        VStack {
          Text("Calling the Model")
            .font(.title.bold())
          
          Text("Once you've defined your structured output type, you can call the model to generate an instance of that type. The Foundation Models framework takes care of guiding the model to produce the structured output based on your definition.")
            .padding(.vertical, 4)
            .padding(.horizontal)
          
          CodeViewer(code: callingModel, language: "swift")
        }
      }
    }
  }
}

#Preview(traits: .landscapeRight) {
  //  GuidedGeneration1()
  GuidedGeneration2()
    .environment(FoundationModelsService.shared)
}
