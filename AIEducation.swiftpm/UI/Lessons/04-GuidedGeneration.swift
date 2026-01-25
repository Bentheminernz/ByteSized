//
//  04-GuidedGeneration.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: Completed

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

  @State var plainTextRecipe: String = ""
  @State var structuredRecipe: Recipe.PartiallyGenerated? = nil

  @Generable
  struct Recipe {
    @Guide(description: "A salivating recipe name")
    var name: String

    @Guide(description: "A brief description of the recipe")
    var description: String

    @Guide(description: "A list of ingredients required for the recipe")
    var ingredients: [Ingredient]

    @Generable
    struct Ingredient {
      var name: String
      var quantity: String
    }

    @Guide(description: "Step-by-step instructions to prepare the recipe")
    var instructions: [Instruction]

    @Generable
    struct Instruction {
      var stepNumber: Int
      var description: String
    }
  }

  var body: some View {
    HStack {
      VStack {
        Text("If you wanted to get an LLM to generate you a recipe, it would return something like this:")
        //        .foregroundStyle(.secondary)
        
        if !plainTextRecipe.isEmpty {
          ScrollView {
            Text(plainTextRecipe)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .glassEffect(in: .rect(cornerRadius: 10))
          .intelligence(in: .rect(cornerRadius: 10))
        }
        
        Text("This output is easy to read as a human, but is near impossible to work with programmatically! You'd have to use some brittle parsing logic to extract the relevant fields, which is not a good practice. Instead, by guiding the model to return structured data, you can get reliable, predictable outputs that are easy to work with.")
          .foregroundStyle(.secondary)
          .padding(.top, 4)
      }
      
      Divider()
        .padding()
      
      VStack(alignment: .leading, spacing: 12) {
        if let recipe = structuredRecipe {
          VStack(spacing: 8) {
            Text("From that, we could format the structured output like so:")
              .foregroundStyle(.secondary)
            
            ScrollView {
              VStack(alignment: .leading, spacing: 10) {
                if let name = recipe.name {
                  Text(name)
                    .font(.title3.bold())
                }
                
                if let description = recipe.description {
                  Text(description)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }
                
                if let ingredients = recipe.ingredients {
                  VStack(alignment: .leading, spacing: 2) {
                    Text("Ingredients:")
                      .font(.subheadline.bold())
                    
                    ForEach(ingredients.indices, id: \.self) { idx in
                      let ingredient = ingredients[idx]
                      if let ingredientName = ingredient.name,
                         let quantity = ingredient.quantity
                      {
                        Text("- \(quantity) of \(ingredientName)")
                          .font(.subheadline)
                      }
                    }
                  }
                  .padding(.top, 4)
                }
                
                if let instructions = recipe.instructions {
                  VStack(alignment: .leading, spacing: 2) {
                    Text("Instructions:")
                      .font(.subheadline.bold())
                    
                    ForEach(instructions.indices, id: \.self) { idx in
                      let instruction = instructions[idx]
                      if let stepNumber = instruction.stepNumber,
                         let description = instruction.description
                      {
                        Text("\(stepNumber). \(description)")
                          .font(.subheadline)
                      }
                    }
                  }
                  .padding(.top, 4)
                }
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }
        }

        if structuredRecipe != nil {
          VStack(spacing: 8) {
            Text("Or we might want to format it as JSON for an API:")
              .foregroundStyle(.secondary)
            
            ScrollView {
              CodeViewer(
                code: buildJsonString(),
                language: "json",
                fontSize: 12,
                lineFontSize: 14
              )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }
        }
      }
    }
    .onAppear {
      foundationModelsService.createSession(for: [
        sessionPlainText, sessionStructured,
      ])
    }
    .task {
      try? await generateRecipes()
    }
    .onDisappear {
      foundationModelsService.clearSession(for: [
        sessionPlainText, sessionStructured,
      ])
    }
  }
  
  func generateRecipes() async throws {
    do {
      let response = foundationModelsService.streamResponse(
        from: sessionPlainText,
        options: GenerationOptions(maximumResponseTokens: 300)
      ) {
        """
        Create a family-friendly gourmet recipe that is safe to prepare at home.

        Requirements:
        - No alcohol
        - No raw or undercooked ingredients
        - Suitable for all ages
        - Uses common kitchen equipment
        - Includes a name, short description, ingredient list, and clear step-by-step instructions
        - Follow basic food safety practices

        The meal should be impressive but simple and safe.
        """
      }

      for try await content in response {
        withAnimation(.bouncy) {
          plainTextRecipe = content.content
        }
      }
      foundationModelsService.completeStream(for: sessionPlainText)

      let responseStruct = foundationModelsService.streamResponse(
        from: sessionStructured,
        generating: Recipe.self
      ) {
        """
        Create a family-friendly gourmet-style meal that is safe to prepare at home.

        Constraints:
        - No alcohol
        - No raw or undercooked meat, eggs, or seafood
        - Appropriate for all ages
        - Clear, safe cooking steps
        - Realistic ingredient quantities

        The recipe should be impressive but safe and practical.
        """
      }

      for try await content in responseStruct {
        withAnimation(.bouncy) {
          structuredRecipe = content.content
        }
      }
      foundationModelsService.completeStream(for: sessionStructured)
    } catch let error as LanguageModelSession.GenerationError {
      print("Generation error: \(error)")
    } catch {
      print("Unexpected error: \(error)")
    }
  }

  func buildJsonString() -> String {
    guard let recipe = structuredRecipe,
      let name = recipe.name,
      let description = recipe.description,
      let ingredients = recipe.ingredients,
      let instructions = recipe.instructions
    else {
      return "{}"
    }

    var jsonString = "{\n"
    jsonString += "  \"name\": \"\(name)\",\n"
    jsonString += "  \"description\": \"\(description)\",\n"
    jsonString += "  \"ingredients\": [\n"
    for (index, ingredient) in ingredients.enumerated() {
      if let ingredientName = ingredient.name,
        let quantity = ingredient.quantity
      {
        jsonString += "    {\n"
        jsonString += "      \"name\": \"\(ingredientName)\",\n"
        jsonString += "      \"quantity\": \"\(quantity)\"\n"
        jsonString += "    }"
        if index < ingredients.count - 1 {
          jsonString += ","
        }
        jsonString += "\n"
      }
    }
    jsonString += "  ],\n"
    jsonString += "  \"instructions\": [\n"
    for (index, instruction) in instructions.enumerated() {
      if let stepNumber = instruction.stepNumber,
        let desc = instruction.description
      {
        jsonString += "    {\n"
        jsonString += "      \"stepNumber\": \(stepNumber),\n"
        jsonString += "      \"description\": \"\(desc)\"\n"
        jsonString += "    }"
        if index < instructions.count - 1 {
          jsonString += ","
        }
        jsonString += "\n"
      }
    }
    jsonString += "  ]\n"
    jsonString += "}"

    return jsonString
  }
}

struct GuidedGeneration3: View {
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Text(
          "Hang on though, aren't LLMs designed to generate text for humans to read? Why do we want to do the opposite?"
        )
        .font(.title.bold())

        Text(
          """
            That is a great question! Structured data outputs are incredibly useful when you want to do more than show a wall of text to a user.
            What about completely unique characters in a game, dynamic product descriptions in an e-commerce app, or personalized workout plans in a fitness app?
            All of these use cases require the app to understand and manipulate the generated content programmatically.
            Lets look at how we can achieve this using the Apple Foundation Models framework.
          """
        )
      }
      Spacer()
    }
  }
}

struct GuidedGeneration4: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  @Environment(\.colorScheme) private var colorScheme

  let generableStruct = """
    import FoundationModels

    @Generable
    struct Recipe {
      @Guide(description: "A salivating recipe name")
      var name: String

      @Guide(description: "A brief description of the recipe")
      var description: String

      @Guide(description: "A list of ingredients required for the recipe")
      var ingredients: [Ingredient]

      @Generable
      struct Ingredient {
        var name: String
        var quantity: String
      }

      @Guide(description: "Step-by-step instructions to prepare the recipe")
      var instructions: [Instruction]

      @Generable
      struct Instruction {
        var stepNumber: Int
        var description: String
      }
    }
    """

  let callingModel = #"""
    import FoundationModels

    // Create a language model session
    let session = LanguageModelSession()

    // Generate a structured Recipe object
    let response = try await session.respond(
      generating: Recipe.self
    ) {
      "Generate me a delicious and easy-to-make recipe for a family dinner."
    }

    // Prints the whole generated Recipe struct
    print("Generated Recipe: \(response.content)")

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
            "Using the Apple Foundation Models framework it is incredibly easy to define structured outputs for the on-device LLM to generate. You simply define a Swift struct with the \(Text("@Generable").monospaced().foregroundStyle(Colours.xcodeClass(colorScheme))) attribute and annotate any fields you want to guide the model on using the \(Text("@Guide").monospaced().foregroundStyle(Colours.xcodeClass(colorScheme))) attribute."
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

          Text(
            "Once you've defined your structured output type, you can call the model to generate an instance of that type. The Foundation Models framework takes care of guiding the model to produce the structured output based on your definition."
          )
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
