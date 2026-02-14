//
//  04-GuidedGeneration.swift
//  ByteSized
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: Completed

import FoundationModels
import SwiftUI

struct GuidedGeneration1: View {
  var body: some View {
    VStack(alignment: .center, spacing: 30) {
      Text("Large Language Models generate human-like text by design.")
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
      
      Text(
        "While perfect for chatbots or content creation, free-form text becomes a problem when you need structured data in your apps."
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      
      HStack(spacing: 20) {
        VStack(spacing: 12) {
          Image(systemName: "text.bubble")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundStyle(.orange)
            .symbolColorRenderingMode(.gradient)
          
          Text("Free-Form Text")
            .font(.headline)
          
          Text(
            "Great for humans, but hard for apps to parse and use reliably."
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
          .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 300)
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .foregroundStyle(.secondary)
        
        VStack(spacing: 12) {
          Image(systemName: "doc.text.below.ecg")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundStyle(.green)
            .symbolColorRenderingMode(.gradient)
          
          Text("Structured Output")
            .font(.headline)
          
          Text(
            "Predictable, organized data that apps can easily process and use."
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
          .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 300)
      }
      
      Text(
        "Structured outputs force the model to return information in an exact format you specify, making it as reliable as any other data source your app uses."
      )
      .font(.body)
      .foregroundStyle(.secondary)
      .multilineTextAlignment(.center)
      .padding(.horizontal, 40)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
    VStack {
      HStack(spacing: 24) {
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "text.alignleft")
              .font(.title2)
              .foregroundStyle(.orange)
            Text("Free-Form Text Output")
              .font(.title2.bold())
          }
          
          DefinableText(
            "If you wanted an LLM to generate a recipe, it would return something like this:"
          )
          .font(.subheadline)
          .foregroundStyle(.secondary)
          
          if !plainTextRecipe.isEmpty {
            ScrollView {
              Text(plainTextRecipe)
                .font(.body)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }
          
          HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundStyle(.yellow)
            Text(
              "This output is easy to read as a human, but really hard to use in an app! You'd need to write fragile parsing code that tries to pick out the specific pieces of information, which breaks very easily when the response format changes even slightly."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 8))
        }
        
        Divider()
        
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "doc.text.below.ecg")
              .font(.title2)
              .foregroundStyle(.green)
            Text("Structured Output")
              .font(.title2.bold())
          }
          if let recipe = structuredRecipe {
            VStack(spacing: 12) {
              Text("Formatted as a user-friendly display:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
              
              ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                  if let name = recipe.name {
                    HStack {
                      Image(systemName: "fork.knife")
                        .foregroundStyle(.green)
                      Text(name)
                        .font(.title3.bold())
                    }
                  }
                  
                  if let description = recipe.description {
                    Text(description)
                      .foregroundStyle(.secondary)
                      .font(.subheadline)
                  }
                  
                  if let ingredients = recipe.ingredients {
                    VStack(alignment: .leading, spacing: 6) {
                      HStack {
                        Image(systemName: "list.bullet")
                          .foregroundStyle(.green)
                        Text("Ingredients")
                          .font(.headline)
                      }
                      
                      ForEach(ingredients.indices, id: \.self) { idx in
                        let ingredient = ingredients[idx]
                        if let ingredientName = ingredient.name,
                           let quantity = ingredient.quantity
                        {
                          HStack(alignment: .top, spacing: 8) {
                            Circle()
                              .fill(.green)
                              .frame(width: 6, height: 6)
                              .padding(.top, 6)
                            Text("\(quantity) of \(ingredientName)")
                              .font(.subheadline)
                          }
                        }
                      }
                    }
                    .padding(.top, 8)
                  }
                  
                  if let instructions = recipe.instructions {
                    VStack(alignment: .leading, spacing: 6) {
                      HStack {
                        Image(systemName: "number")
                          .foregroundStyle(.green)
                        Text("Instructions")
                          .font(.headline)
                      }
                      
                      ForEach(instructions.indices, id: \.self) { idx in
                        let instruction = instructions[idx]
                        if let stepNumber = instruction.stepNumber,
                           let description = instruction.description
                        {
                          HStack(alignment: .top, spacing: 8) {
                            Text("\(stepNumber)")
                              .font(.caption.bold())
                              .foregroundStyle(.white)
                              .frame(width: 24, height: 24)
                              .background(Circle().fill(.green))
                            Text(description)
                              .font(.subheadline)
                          }
                        }
                      }
                    }
                    .padding(.top, 8)
                  }
                }
                .padding(4)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
              .padding()
              .glassEffect(in: .rect(cornerRadius: 10))
              .intelligence(in: .rect(cornerRadius: 10))
            }
          }
          
          // I really want to include this but I don't think it fits the app...
          //        if structuredRecipe != nil {
          //          VStack(spacing: 12) {
          //            HStack {
          //              Image(systemName: "chevron.left.forwardslash.chevron.right")
          //                .foregroundStyle(.green)
          //              DefinableText(
          //                "Or export as JSON for other software:"
          //              )
          //              .font(.subheadline)
          //              .foregroundStyle(.secondary)
          //            }
          //            .frame(maxWidth: .infinity, alignment: .leading)
          //
          //            ScrollView {
          //              CodeViewer(
          //                code: buildJsonString(),
          //                language: .json,
          //                fontSize: 12,
          //                lineFontSize: 14
          //              )
          //              .accessibilityLabel("Generated recipe in JSON format")
          //            }
          //            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
          //            .glassEffect(in: .rect(cornerRadius: 10))
          //            .intelligence(in: .rect(cornerRadius: 10))
          //          }
          //        }
          
          if structuredRecipe != nil {
            HStack(alignment: .top, spacing: 8) {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text(
                "By telling the model to return organized data in a specific format, you get consistent, predictable results that your app can actually use!"
              )
              .font(.caption)
              .foregroundStyle(.secondary)
            }
            .padding(12)
            .glassEffect(.regular, in: .rect(cornerRadius: 8))
          }
        }
      }
      
      if !plainTextRecipe.isEmpty && structuredRecipe != nil {
        Button(action: {
          Task {
            try? await generateRecipes()
          }
        }) {
          Label("Regenerate Recipes", systemImage: "arrow.clockwise.circle.fill")
            .font(.headline)
            .foregroundStyle(.blue)
        }
        .buttonStyle(.glass)
        .disabled(foundationModelsService.status(for: sessionPlainText) == .generating || foundationModelsService.status(for: sessionStructured) == .generating || foundationModelsService.status(for: sessionPlainText) == .requested || foundationModelsService.status(for: sessionStructured) == .requested)
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
        options: GenerationOptions(maximumResponseTokens: 400)
      ) {
        """
        Create me a recipe for homemade herb crusted chicken with roasted vegetables.
        Just return the recipe, don't include any extra commentary or fluff. Make sure the recipe is safe and practical for home cooks, with clear instructions and realistic ingredient quantities.
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
        Create me a recipe for homemade herb crusted chicken with roasted vegetables.
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
    VStack(alignment: .center, spacing: 30) {
      Text(
        "Why Structure AI Output?"
      )
      .font(.largeTitle.bold())
      .multilineTextAlignment(.center)
      
      Text(
        "Aren't LLMs designed to generate text for humans to read?"
      )
      .font(.title2)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)

      Text(
        "That is a great question! Structured data outputs are incredibly useful when apps need to work with AI's responses, not just display them."
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      
      HStack(spacing: 20) {
        VStack(spacing: 12) {
          Image(systemName: "calendar.badge.clock")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.purple)
            .symbolColorRenderingMode(.gradient)
          
          Text("Smart Scheduling")
            .font(.headline)
          
          Text("Create organized calendars with times, locations, and reminders all ready to use")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
        
        VStack(spacing: 12) {
          Image(systemName: "fork.knife")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.blue)
            .symbolColorRenderingMode(.gradient)
          
          Text("Meal Planning")
            .font(.headline)
          
          Text("Generate shopping lists and step-by-step cooking instructions your kitchen app can follow")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
        
        VStack(spacing: 12) {
          Image(systemName: "chart.line.uptrend.xyaxis")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.green)
            .symbolColorRenderingMode(.gradient)
          
          Text("Budget Tracking")
            .font(.headline)
          
          Text("Organize expenses into categories with amounts that can be graphed and analysed")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
      }
      
      Text(
        "All of these require apps to actually process and use the AI's output in meaningful ways."
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      
      Text("Let's look at how this works using the Apple Foundation Models framework.")
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
}

struct GuidedGeneration4: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  @Environment(\.colorScheme) private var colorScheme

  let generableStruct = """
    import FoundationModels

    // Creates a Recipe structure using the @Generable macro
    @Generable
    struct Recipe {
      // Fields annotated with @Guide provide context to the model
      @Guide(description: "A salivating recipe name")
      var name: String

      @Guide(description: "A brief description of the recipe")
      var description: String

      @Guide(description: "A list of ingredients required for the recipe")
      var ingredients: [Ingredient]

      // Creates an Ingredient structure using the @Generable macro
      @Generable
      struct Ingredient {
        var name: String
        var quantity: String
      }

      @Guide(description: "Step-by-step instructions to prepare the recipe")
      var instructions: [Instruction]

      // Creates an Instruction structure using the @Generable macro
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
    HStack(spacing: 24) {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Image(systemName: "swift")
              .font(.title)
              .foregroundStyle(.orange)
            Text("Defining a Structured Output")
              .font(.title.bold())
          }

          VStack(alignment: .leading, spacing: 8) {
            Text(
              "Using the Apple Foundation Models framework it is incredibly easy to define structured outputs for the on-device LLM to generate."
            )
            .font(.body)
            
            HStack(alignment: .top, spacing: 8) {
              Image(systemName: "1.circle.fill")
                .foregroundStyle(.blue)
              VStack(alignment: .leading, spacing: 4) {
                Text("Define a Swift struct with the \(Text("@Generable").monospaced().foregroundStyle(Colours.xcodeClass(colorScheme))) attribute")
                  .font(.subheadline)
              }
            }
            
            HStack(alignment: .top, spacing: 8) {
              Image(systemName: "2.circle.fill")
                .foregroundStyle(.blue)
              VStack(alignment: .leading, spacing: 4) {
                Text("Annotate fields with \(Text("@Guide").monospaced().foregroundStyle(Colours.xcodeClass(colorScheme))) to provide context")
                  .font(.subheadline)
              }
            }
          }
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 10))

          CodeViewer(code: generableStruct, language: .swift)
            .padding(.top, 8)
        }
        .padding()
      }

      Divider()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Image(systemName: "play.circle.fill")
              .font(.title)
              .foregroundStyle(.green)
            Text("Calling the Model")
              .font(.title.bold())
          }

          VStack(alignment: .leading, spacing: 12) {
            Text(
              "Once you've defined your structured output type, you can call the model to generate an instance of that type."
            )
            .font(.body)
            
            HStack(alignment: .top, spacing: 8) {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("The Foundation Models framework takes care of guiding the model to produce the structured output based on your definition.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
          }
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 10))

          CodeViewer(code: callingModel, language: .swift)
            .padding(.top, 8)
        }
        .padding()
      }
    }
  }
}
