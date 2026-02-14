//
//  DynamicSchemaBuilder.swift
//  ByteSized
//
//  Created by Ben Lawrence on 10/01/2026.
//

import Foundation
import FoundationModels
import SwiftUI

/// A simple description of a single field in a dynamic schema that can be mapped
/// to a FoundationModels DynamicGenerationSchema.
struct SchemaField: Identifiable, Codable {
  var id = UUID()

  /// Name of the field
  var name: String

  /// Type of the field (e.g., String, Int, [String], etc.)
  var type: FieldType

  /// Description of the field (equivalent of @Guide)
  var description: String

  /// Amount of elements for array types (if applicable, equivalent of @Guide(.count(n)))
  var arrayCount: Int?

  enum FieldType: String, CaseIterable, Codable {
    case string = "String (Text)"
    case int = "Integer (A whole number)"
    case double = "Double (A decimal number)"
    case bool = "Bool (True/False)"
    case stringArray = "[String] (A collection of text values)"
    case intArray = "[Int] (A collection of whole numbers)"
  }
}

/// A builder that converts a list of SchemaField entries into a DynamicGenerationSchema
/// suitable for guided generation with LanguageModelSession.
struct DynamicSchemaBuilder: Codable {
  /// Optional display name for the object being generated (e.g., "PlayerCharacter").
  var schemaName: String?
  /// Optional overall description for the object being generated.
  var schemaDescription: String?
  /// The fields to include in the schema.
  var fields: [SchemaField]

  init(
    schemaName: String? = nil,
    schemaDescription: String? = nil,
    fields: [SchemaField]
  ) {
    self.schemaName = schemaName
    self.schemaDescription = schemaDescription
    self.fields = fields
  }
}

extension DynamicSchemaBuilder {
  /// Build a FoundationModels.DynamicGenerationSchema representing an object with the given fields.
  /// All fields are considered required. You can extend this with optionality as needed.
  func makeDynamicSchema() -> DynamicGenerationSchema {
    let properties: [DynamicGenerationSchema.Property] = fields.map { field in
      DynamicGenerationSchema.Property(
        name: field.name,
        description: propertyDescription(for: field),
        schema: mapFieldToDynamicSchema(field)
      )
    }
    return DynamicGenerationSchema(
      name: schemaName ?? "GeneratedObject",
      description: schemaDescription,
      properties: properties
    )
  }

  /// Wrap the dynamic schema into a GenerationSchema root for use with LanguageModelSession.
  func makeGenerationSchema() throws -> GenerationSchema {
    try GenerationSchema(root: makeDynamicSchema(), dependencies: [])
  }

  /// Map a single SchemaField to its corresponding DynamicGenerationSchema node.
  private func mapFieldToDynamicSchema(_ field: SchemaField)
    -> DynamicGenerationSchema
  {
    switch field.type {
    case .string:
      return DynamicGenerationSchema(type: String.self)
    case .int:
      return DynamicGenerationSchema(type: Int.self)
    case .double:
      return DynamicGenerationSchema(type: Double.self)
    case .bool:
      return DynamicGenerationSchema(type: Bool.self)
    case .stringArray:
      return DynamicGenerationSchema(type: [String].self)
    case .intArray:
      return DynamicGenerationSchema(type: [Int].self)
    }
  }

  /// Combine the field's description with guidance like array count (if provided).
  private func propertyDescription(for field: SchemaField) -> String? {
    if let count = field.arrayCount {
      // Provide light guidance about expected element count
      return "\(field.description) (Count: \(count))"
    }
    return field.description
  }
}

struct ExampleSchema {
  static let superheroSchemaFields: [SchemaField] = [
    SchemaField(
      name: "name",
      type: .string,
      description: "The superhero's name"
    ),
    SchemaField(
      name: "superpower",
      type: .string,
      description: "The superhero's primary superpower"
    ),
    SchemaField(
      name: "age",
      type: .int,
      description: "The superhero's age"
    ),
    SchemaField(
      name: "isHeroic",
      type: .bool,
      description: "Whether the character is heroic or villainous"
    ),
    SchemaField(
      name: "allies",
      type: .stringArray,
      description: "A list of the superhero's allies",
      arrayCount: 3
    ),
  ]

  static let dogSchemaFields: [SchemaField] = [
    SchemaField(
      name: "name",
      type: .string,
      description: "The dog's name"
    ),
    SchemaField(
      name: "breed",
      type: .string,
      description: "The breed of the dog"
    ),
    SchemaField(
      name: "age",
      type: .int,
      description: "The dog's age in years"
    ),
    SchemaField(
      name: "isTrained",
      type: .bool,
      description: "Whether the dog is trained"
    ),
    SchemaField(
      name: "favouriteToys",
      type: .stringArray,
      description: "A list of the dog's favourite toys",
      arrayCount: 5
    ),
  ]

  static let movieSchemaFields: [SchemaField] = [
    SchemaField(
      name: "title",
      type: .string,
      description: "The movie's title"
    ),
    SchemaField(
      name: "description",
      type: .string,
      description: "A brief description of the movie plot"
    ),
    SchemaField(
      name: "director",
      type: .string,
      description: "The director of the movie"
    ),
    SchemaField(
      name: "releaseYear",
      type: .int,
      description: "The year the movie was released"
    ),
    SchemaField(
      name: "isAnimated",
      type: .bool,
      description: "Whether the movie is animated"
    ),
    SchemaField(
      name: "cast",
      type: .stringArray,
      description: "A list of main cast members",
      arrayCount: 4
    ),
  ]

  static let recipeSchemaFields: [SchemaField] = [
    SchemaField(
      name: "name",
      type: .string,
      description: "The name of the recipe"
    ),
    SchemaField(
      name: "servings",
      type: .int,
      description: "Number of servings the recipe makes"
    ),
    SchemaField(
      name: "isVegetarian",
      type: .bool,
      description: "Whether the recipe is vegetarian"
    ),
    SchemaField(
      name: "ingredients",
      type: .stringArray,
      description: "List of ingredients required",
      arrayCount: 8
    ),
    SchemaField(
      name: "steps",
      type: .stringArray,
      description: "Step-by-step instructions",
      arrayCount: 6
    ),
  ]

  static let personSchemaFields: [SchemaField] = [
    SchemaField(
      name: "firstName",
      type: .string,
      description: "The person's first name"
    ),
    SchemaField(
      name: "lastName",
      type: .string,
      description: "The person's last name"
    ),
    SchemaField(
      name: "age",
      type: .int,
      description: "The person's age"
    ),
    SchemaField(
      name: "isEmployed",
      type: .bool,
      description: "Whether the person is currently employed"
    ),
    SchemaField(
      name: "hobbies",
      type: .stringArray,
      description: "A list of the person's hobbies",
      arrayCount: 4
    ),
    SchemaField(
      name: "favouriteNumbers",
      type: .intArray,
      description: "A list of the person's favourite numbers",
      arrayCount: 3
    ),
  ]

  static let schemaFields:
    [(name: String, fields: [SchemaField], examplePrompt: String)] = [
      (
        name: "Superhero", fields: superheroSchemaFields,
        examplePrompt: "Generate a super cool superhero character!"
      ),
      (
        name: "Dog", fields: dogSchemaFields,
        examplePrompt: "Create an adorable dog profile!"
      ),
      (
        name: "Movie", fields: movieSchemaFields,
        examplePrompt: "Suggest a blockbuster movie idea!"
      ),
      (
        name: "Recipe", fields: recipeSchemaFields,
        examplePrompt: "Invent a delicious new recipe!"
      ),
      (
        name: "Person", fields: personSchemaFields,
        examplePrompt: "Describe a fascinating person!"
      ),
    ]
}

// MARK: - Usage notes

/**
 let session = LanguageModelSession()
 let prompt = "Generate a whimsical player character."

 // Build a dynamic schema at runtime
 let builder = DynamicSchemaBuilder(
     schemaName: "PlayerCharacter",
     schemaDescription: "PlayerCharacter",
     fields: [
         SchemaField(name: "name", type: .string, description: "A funky name for the character"),
         SchemaField(name: "age", type: .int, description: "The age of the character"),
         SchemaField(name: "personalityTraits", type: .stringArray, description: "A list of personality traits", arrayCount: 4)
     ]
 )
 let dynamic = builder.makeDynamicSchema()
 let schema = try GenerationSchema(root: dynamic, dependencies: [])

 // Request a structured response guided by the dynamic schema
 let response = try await session.respond(
     to: prompt,
     schema: schema
 )

 // You can also define a result type conforming to ConvertibleFromGeneratedContent
 // and initialize it from response.content.
 */

// MARK: - UI Components
struct SchemaBuilderView: View {
  @State private var schemaName = "CustomSchema"
  @State private var schemaDescription = ""
  @State private var fields: [SchemaField] = []
  @State private var showingAddField = false
  @State private var editingField: SchemaField?
  @State private var systemPrompt = "You are a helpful assistant."
  @State private var userPrompt = ""
  @State private var generatedResult: [String: Any]?
  @State private var isGenerating = false
  @State private var errorMessage: String?

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        // Schema Definition
        List {
          Section("Schema Information") {
            TextField("Name", text: $schemaName)
            TextField("Description", text: $schemaDescription, axis: .vertical)
              .lineLimit(2...4)
          }

          Section("Fields") {
            ForEach(fields) { field in
              FieldRow(field: field)
                .contentShape(Rectangle())
                .onTapGesture {
                  editingField = field
                }
            }
            .onDelete { indexSet in
              fields.remove(atOffsets: indexSet)
            }

            Button {
              showingAddField = true
            } label: {
              Label("Add Field", systemImage: "plus.circle.fill")
            }
          }

          Section("System Prompt") {
            TextField(
              "System instructions",
              text: $systemPrompt,
              axis: .vertical
            )
            .lineLimit(3...6)
          }

          Section("User Prompt") {
            TextField(
              "What should the AI generate?",
              text: $userPrompt,
              axis: .vertical
            )
            .lineLimit(3...6)
          }

          if let error = errorMessage {
            Section("Error") {
              Text(error)
                .foregroundStyle(.red)
                .font(.caption)
            }
          }
        }

        // Generate Button
        Button {
          Task { await generate() }
        } label: {
          if isGenerating {
            ProgressView()
          } else {
            Text("Generate")
              .frame(maxWidth: .infinity)
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(fields.isEmpty || userPrompt.isEmpty || isGenerating)
        .padding()

        // Results
        if let result = generatedResult {
          ResultView(result: result, fields: fields)
        }
      }
      .navigationTitle("Schema Builder")
      .sheet(isPresented: $showingAddField) {
        AddFieldView { field in
          fields.append(field)
        }
      }
      .sheet(item: $editingField) { field in
        EditFieldView(field: field) { updatedField in
          if let index = fields.firstIndex(where: { $0.id == field.id }) {
            fields[index] = updatedField
          }
        }
      }
    }
  }

  func generate() async {
    isGenerating = true
    errorMessage = nil
    defer { isGenerating = false }

    do {
      // Build dynamic schema using your existing DynamicSchemaBuilder
      let builder = DynamicSchemaBuilder(
        schemaName: schemaName,
        schemaDescription: schemaDescription.isEmpty ? nil : schemaDescription,
        fields: fields
      )

      // Use the builder's method to create GenerationSchema
      let schema = try builder.makeGenerationSchema()

      // Create session with system prompt
      let session = LanguageModelSession(instructions: systemPrompt)

      // Generate response
      let response = try await session.respond(
        to: userPrompt,
        schema: schema
      )

      // Parse results - extract values directly
      var result: [String: Any] = [:]
      for field in fields {
        switch field.type {
        case .string:
          result[field.name] = try response.content.value(
            String.self,
            forProperty: field.name
          )
        case .int:
          result[field.name] = try response.content.value(
            Int.self,
            forProperty: field.name
          )
        case .double:
          result[field.name] = try response.content.value(
            Double.self,
            forProperty: field.name
          )
        case .bool:
          result[field.name] = try response.content.value(
            Bool.self,
            forProperty: field.name
          )
        case .stringArray:
          result[field.name] = try response.content.value(
            [String].self,
            forProperty: field.name
          )
        case .intArray:
          result[field.name] = try response.content.value(
            [Int].self,
            forProperty: field.name
          )
        }
      }
      generatedResult = result

    } catch {
      errorMessage = "Generation failed: \(error.localizedDescription)"
      print("Generation error: \(error)")
    }
  }
}

struct FieldRow: View {
  let field: SchemaField

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(field.name)
          .font(.headline)
        Spacer()
        Text(field.type.rawValue)
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      if !field.description.isEmpty {
        Text(field.description)
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      if let count = field.arrayCount {
        Text("Count: \(count)")
          .font(.caption2)
          .foregroundStyle(.blue)
      }
    }
    .padding(.vertical, 4)
  }
}

struct AddFieldView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var name = ""
  @State private var type = SchemaField.FieldType.string
  @State private var description = ""
  @State private var arrayCount: Int?
  @State private var showArrayCount = false

  let onAdd: (SchemaField) -> Void

  var body: some View {
    NavigationStack {
      Form {
        TextField("Field Name", text: $name)
          .autocapitalization(.none)

        Picker("Type", selection: $type) {
          ForEach(SchemaField.FieldType.allCases, id: \.self) { type in
            Text(type.rawValue).tag(type)
          }
        }
        .onChange(of: type) { _, newType in
          showArrayCount = newType == .stringArray || newType == .intArray
          if !showArrayCount {
            arrayCount = nil
          }
        }

        TextField(
          "Description (guide for AI)",
          text: $description,
          axis: .vertical
        )
        .lineLimit(2...4)

        if showArrayCount {
          Toggle(
            "Set Max Item Count",
            isOn: Binding(
              get: { arrayCount != nil },
              set: { arrayCount = $0 ? 4 : nil }
            )
          )

          if arrayCount != nil {
            Stepper(
              "Count: \(arrayCount!)",
              value: Binding(
                get: { arrayCount ?? 4 },
                set: { arrayCount = $0 }
              ),
              in: 1...20
            )
          }
        }
      }
      .navigationTitle("Add Field")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            let field = SchemaField(
              name: name,
              type: type,
              description: description,
              arrayCount: arrayCount
            )
            onAdd(field)
            dismiss()
          }
          .disabled(name.isEmpty)
        }
      }
    }
  }
}

struct EditFieldView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var name: String
  @State private var type: SchemaField.FieldType
  @State private var description: String
  @State private var arrayCount: Int?
  @State private var showArrayCount: Bool

  let field: SchemaField
  let onSave: (SchemaField) -> Void

  init(field: SchemaField, onSave: @escaping (SchemaField) -> Void) {
    self.field = field
    self.onSave = onSave
    _name = State(initialValue: field.name)
    _type = State(initialValue: field.type)
    _description = State(initialValue: field.description)
    _arrayCount = State(initialValue: field.arrayCount)
    _showArrayCount = State(
      initialValue: field.type == .stringArray || field.type == .intArray
    )
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Field Name", text: $name)
          .autocapitalization(.none)

        Picker("Type", selection: $type) {
          ForEach(SchemaField.FieldType.allCases, id: \.self) { type in
            Text(type.rawValue).tag(type)
          }
        }
        .onChange(of: type) { _, newType in
          showArrayCount = newType == .stringArray || newType == .intArray
          if !showArrayCount {
            arrayCount = nil
          }
        }

        TextField(
          "Description (guide for AI)",
          text: $description,
          axis: .vertical
        )
        .lineLimit(2...4)

        if showArrayCount {
          Toggle(
            "Set Max Item Count",
            isOn: Binding(
              get: { arrayCount != nil },
              set: { arrayCount = $0 ? 4 : nil }
            )
          )

          if arrayCount != nil {
            Stepper(
              "Count: \(arrayCount!)",
              value: Binding(
                get: { arrayCount ?? 4 },
                set: { arrayCount = $0 }
              ),
              in: 1...20
            )
          }
        }
      }
      .navigationTitle("Edit Field")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            let updatedField = SchemaField(
              name: name,
              type: type,
              description: description,
              arrayCount: arrayCount
            )
            onSave(updatedField)
            dismiss()
          }
          .disabled(name.isEmpty)
        }
      }
    }
  }
}

struct ResultView: View {
  let result: [String: Any]
  let fields: [SchemaField]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Generated Result")
        .font(.headline)
        .padding(.horizontal)

      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(fields, id: \.id) { field in
            if let value = result[field.name] {
              VStack(alignment: .leading, spacing: 4) {
                Text(field.name)
                  .font(.caption)
                  .foregroundStyle(.secondary)
                Text(formatValue(value))
                  .font(.body)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
              .background(Color(.systemGray6))
              .cornerRadius(8)
            }
          }
        }
        .padding()
      }
    }
    .frame(maxHeight: 300)
  }

  func formatValue(_ value: Any) -> String {
    if let array = value as? [Any] {
      return array.map { "\($0)" }.joined(separator: ", ")
    }
    return "\(value)"
  }
}
