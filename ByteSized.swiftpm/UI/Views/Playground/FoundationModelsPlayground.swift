//
//  FoundationModelsPlayground.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import FoundationModels
import HighlightSwift
import SwiftUI

struct FoundationModelsPlayground: View {
  let highlight: Highlight

  init(highlight: Highlight = Highlight()) {
    self.highlight = highlight
  }

  @State private var userInput: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""
  @State private var generationMode: GenerationMode = .stream

  @State private var swiftCodeOutput: String?

  // Schema support
  @State private var outputMode: OutputMode = .string
  @State private var schemaFields: [SchemaField] = []
  @State private var showingSchemaBuilder = false
  @State private var schemaResult: [String: Any]?

  // Generation options
  @State private var temperature: Double = 0.5
  @State private var maxTokens: Int = 2000
  
  // Copy feedback
  @State private var justCopied: Bool = false

  enum GenerationMode {
    case stream
    case respondTo
  }

  enum OutputMode {
    case string
    case schema
  }

  @Environment(\.colorScheme) private var colorScheme: ColorScheme

  private var fullCode: String {
    let header = """
      import FoundationModels

      // Creates the language model session
      let model = LanguageModelSession()

      // Sets up the generation options
      let generationOptions = GenerationOptions(
        temperature: \(String(format: "%.1f", temperature)),
        maximumResponseTokens: \(maxTokens)
      )

      """

    if outputMode == .schema && !schemaFields.isEmpty {
      let schemaCode = generateSchemaCode()
      let callCode = """

        // Calls the model to generate a response with schema
        let response = try await model.respond(
          to: \"\"\"
              \(userInput)
              \"\"\",
          generating: CustomSchema.self,
          options: generationOptions
        )

        // Access the generated values
        \(generateExtractionCode())
        """
      return header + schemaCode + callCode
    } else {
      let callPrefix =
        generationMode == .stream
        ? "let response = model.streamResponse(\n"
        : "let response = try await model.respond(\n"
      let body = """
          to: \"\"\"
              \(userInput)
              \"\"\",
          options: generationOptions
        )

        \(generationMode == .stream ? "// Streams the response content\n" : "// Gets the full response content at once\n")
        """

      let suffix =
        generationMode == .stream
        ? "for try await content in response {\n    print(content.content)\n}"
        : "print(response.content)"

      return header + callPrefix + body + suffix
    }
  }

  private func generateSchemaCode() -> String {
    let properties = schemaFields.map { field -> String in
      let guideAttribute: String
      let propertyType: String

      switch field.type {
      case .string:
        propertyType = "String"
        if field.description.isEmpty {
          guideAttribute = ""
        } else {
          guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
        }
      case .int:
        propertyType = "Int"
        if field.description.isEmpty {
          guideAttribute = ""
        } else {
          guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
        }
      case .double:
        propertyType = "Double"
        if field.description.isEmpty {
          guideAttribute = ""
        } else {
          guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
        }
      case .bool:
        propertyType = "Bool"
        if field.description.isEmpty {
          guideAttribute = ""
        } else {
          guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
        }
      case .stringArray:
        propertyType = "[String]"
        if let count = field.arrayCount {
          if field.description.isEmpty {
            guideAttribute = "  @Guide(.count(\(count)))\n"
          } else {
            guideAttribute =
              "  @Guide(description: \"\(field.description)\", .count(\(count)))\n"
          }
        } else {
          if field.description.isEmpty {
            guideAttribute = ""
          } else {
            guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
          }
        }
      case .intArray:
        propertyType = "[Int]"
        if let count = field.arrayCount {
          if field.description.isEmpty {
            guideAttribute = "  @Guide(.count(\(count)))\n"
          } else {
            guideAttribute =
              "  @Guide(description: \"\(field.description)\", .count(\(count)))\n"
          }
        } else {
          if field.description.isEmpty {
            guideAttribute = ""
          } else {
            guideAttribute = "  @Guide(description: \"\(field.description)\")\n"
          }
        }
      }

      return
        "\(guideAttribute)  var \(field.name.replacingOccurrences(of: " ", with: "")): \(propertyType)"
    }.joined(separator: "\n\n")

    return """
      // Define the schema
      @Generable
      struct CustomSchema {
      \(properties)
      }
      """
  }

  private func generateExtractionCode() -> String {
    """
    print(response)
    // Or access individual properties:
    \(schemaFields.map { "// print(response.content.\($0.name.replacingOccurrences(of: " ", with: "")))" }.joined(separator: "\n"))
    """
  }

  @Environment(FoundationModelsService.self) private var foundationModelsService
  var generationStatus: GenerationState {
    foundationModelsService.statuses[.shared] ?? .idle
  }

  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        // MARK: Left Panel
        ScrollView {
          VStack(alignment: .leading, spacing: 8) {
            Text("Controls")
              .font(.title2).bold()
              .padding(.bottom, 8)

            VStack(alignment: .leading) {
              Text("Temperature: \(String(temperature))")
                .font(.caption)
                .foregroundStyle(.secondary)

              Slider(value: $temperature, in: 0...1, step: 0.1) {
                Text("Temperature: \(String(format: "%.1f", temperature))")
              } minimumValueLabel: {
                Text("0.0")
              } maximumValueLabel: {
                Text("1.0")
              }
              .onChange(of: temperature) { oldValue, newValue in
                temperature = round(newValue * 10) / 10
              }

              Text("Max Tokens: \(String(maxTokens))")
                .font(.caption)
                .foregroundStyle(.secondary)
              Slider(
                value: Binding(
                  get: { Double(maxTokens) },
                  set: { maxTokens = Int($0) }
                ),
                in: 10...4090
              ) {
                Text("Max Tokens: \(maxTokens)")
              } minimumValueLabel: {
                Text("10")
              } maximumValueLabel: {
                Text("4090")
              }

              VStack(alignment: .leading) {
                Text("Output Mode")
                  .font(.subheadline)
                  .foregroundStyle(.secondary)

                Picker("", selection: $outputMode) {
                  Text("String Output").tag(OutputMode.string)
                  Text("Schema Output").tag(OutputMode.schema)
                }
                .pickerStyle(.segmented)
              }
              .padding(.top)

              if outputMode == .string {
                VStack(alignment: .leading) {
                  Text("Generation Mode")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                  Picker("", selection: $generationMode) {
                    Text("Stream Response").tag(GenerationMode.stream)
                    Text("Full Response").tag(GenerationMode.respondTo)
                  }
                  .pickerStyle(.segmented)
                }
                .padding(.top)
              }

              if outputMode == .schema {
                VStack(alignment: .leading, spacing: 8) {
                  HStack {
                    Text("Guided Generation Fields")
                      .font(.subheadline)
                      .foregroundStyle(.secondary)

                    Spacer()

                    Menu {
                      ForEach(
                        ExampleSchema.schemaFields.enumerated(),
                        id: \.offset
                      ) { index, schema in
                        Button(schema.name) {
                          schemaFields = schema.fields
                          userInput = schema.examplePrompt
                        }
                      }
                    } label: {
                      HStack {
                        Text("Load Example Guide")
                          .font(.subheadline)
                        Image(systemName: "chevron.down")
                          .font(.caption)
                      }
                      //                      .padding(4)
                    }
                    .buttonStyle(.glassProminent)

                    Button("Edit Guide", systemImage: "slider.horizontal.3") {
                      showingSchemaBuilder = true
                    }
                    .buttonStyle(.glassProminent)
                    .labelStyle(.iconOnly)
                    .accessibilityLabel("Edit Schema Guide Fields")
                  }

                  if schemaFields.isEmpty {
                    Text("No fields defined")
                      .font(.caption)
                      .foregroundStyle(.secondary)
                      .padding(.vertical, 8)
                  } else {
                    VStack(alignment: .leading, spacing: 4) {
                      ForEach(schemaFields) { field in
                        HStack {
                          Text(field.name)
                            .font(.caption)
                          Spacer()
                          Text(field.type.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                      }
                    }
                    .padding(8)
                    .glassEffect(.regular, in: .rect(cornerRadius: 6))
                  }
                }
                .padding(.top)
              }
            }
            .padding(.bottom, 4)

            VStack(alignment: .leading) {
              Text("Prompt")
                .font(.headline)

              TextEditor(text: $userInput)
                .frame(minHeight: 150)
                .overlay(
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 8))
            }
            .padding(.bottom, 4)

            Spacer()

            Button(action: {
              Task {
                await generateResponse()
              }
            }) {
              Text("Generate Response")
                .font(.headline)
                .frame(maxWidth: .infinity)
            }
            .tint(Color.green.gradient)
            .buttonStyle(.glassProminent)
            .disabled((outputMode == .schema && schemaFields.isEmpty) || userInput.isEmpty || foundationModelsService.statuses[.shared] == .generating)
          }
          .padding()
          .frame(width: geometry.size.width * 0.4)
        }
        .glassEffect(.regular, in: .rect(cornerRadius: 8))

        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              Image(systemName: "sparkles")
                .font(.system(size: 32))
                .symbolEffect(
                  .breathe,
                  isActive: generationStatus == .generating
                )
                .symbolRenderingMode(.multicolor)
                .symbolColorRenderingMode(.gradient)

              Text("Model Output")
                .font(.title2).bold()
            }

            Text(generationStatus.modelStatusText)
              .font(.subheadline)
              .foregroundStyle(.secondary)

            if outputMode == .string && modelOutput != "" {
              Text(modelOutput)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 10))
                .intelligence(in: .rect(cornerRadius: 10))
            }

            if outputMode == .schema, let result = schemaResult {
              VStack(alignment: .leading, spacing: 8) {
                ForEach(schemaFields, id: \.id) { field in
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
                    .glassEffect(in: .rect(cornerRadius: 8))
                  }
                }
              }
            }

            HStack {
              Text("Swift Code Output")
                .font(.headline)

              Spacer()

              Button(
                justCopied ? "Copied!" : "Copy",
                systemImage: justCopied ? "checkmark" : "document.on.document"
              ) {
                UIPasteboard.general.string = fullCode
                withAnimation {
                  justCopied = true
                }
                
                Task {
                  try? await Task.sleep(for: .seconds(2))
                  withAnimation {
                    justCopied = false
                  }
                }
              }
              .contentTransition(.symbolEffect(.replace))
              .buttonStyle(.glassProminent)
              .accessibilityLabel(justCopied ? "Code Copied to Clipboard" : "Copy Swift Code to Clipboard")
            }
            VStack {
              CodeViewer(code: fullCode, language: .swift)
            }
            .glassEffect(in: .rect(cornerRadius: 10))
          }
          .padding()
          .frame(width: geometry.size.width * 0.6)
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .sheet(isPresented: $showingSchemaBuilder) {
      SchemaBuilderSheet(fields: $schemaFields)
    }
    .onAppear {
      //      schemaFields = DynamicSchemaBuilder.superheroSchemaFields
    }
    .onChange(of: outputMode) {
      foundationModelsService.resetContext(for: .shared)
    }
  }

  private func formatValue(_ value: Any) -> String {
    if let array = value as? [Any] {
      return array.map { "\($0)" }.joined(separator: ", ")
    }
    return "\(value)"
  }

  private func generateResponse() async {
    do {
      if outputMode == .schema {
        // generate the schema
        let builder = DynamicSchemaBuilder(
          schemaName: "CustomSchema",
          schemaDescription: "Generated schema",
          fields: schemaFields
        )

        let schema = try builder.makeGenerationSchema()

        let response = try await foundationModelsService.respond(
          generating: schema,
          options: GenerationOptions(
            temperature: temperature,
            maximumResponseTokens: maxTokens
          ),
        ) {
          userInput
        }

        // parses the response into a dictionary
        var result: [String: Any] = [:]
        for field in schemaFields {
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

        withAnimation(.bouncy) {
          schemaResult = result
          modelOutput = ""
        }

      } else {
        schemaResult = nil

        switch generationMode {
        case .stream:
          let response = foundationModelsService.streamResponse(
            options: GenerationOptions(
              temperature: temperature,
              maximumResponseTokens: maxTokens
            )
          ) {
            userInput
          }

          for try await content in response {
            withAnimation(.bouncy) {
              modelOutput = content.content
            }
          }
          foundationModelsService.completeStream(for: .shared)
        case .respondTo:
          let response = try await foundationModelsService.respond(
            options: GenerationOptions(
              temperature: temperature,
              maximumResponseTokens: maxTokens
            )
          ) {
            userInput
          }

          withAnimation(.bouncy) {
            modelOutput = response.content
          }
        }
      }
    } catch {
      print("Unexpected error: \(error)")
      modelOutput =
        "An unexpected error occurred: \(error.localizedDescription)"
    }
  }
}

// MARK: - Schema Builder Sheet
struct SchemaBuilderSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var fields: [SchemaField]

  @State private var localFields: [SchemaField]
  @State private var showingAddField = false
  @State private var editingField: SchemaField?

  init(fields: Binding<[SchemaField]>) {
    _fields = fields
    _localFields = State(initialValue: fields.wrappedValue)
  }

  var body: some View {
    NavigationStack {
      List {
        Section("Schema Fields") {
          ForEach(localFields) { field in
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
            }
            .contentShape(Rectangle())
            .onTapGesture {
              editingField = field
            }
          }
          .onDelete { indexSet in
            localFields.remove(atOffsets: indexSet)
          }

          Button {
            showingAddField = true
          } label: {
            Label("Add Field", systemImage: "plus.circle.fill")
          }
        }
      }
      .navigationTitle("Edit Schema")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            fields = localFields
            dismiss()
          }
        }
      }
      .sheet(isPresented: $showingAddField) {
        AddFieldView { field in
          localFields.append(field)
        }
      }
      .sheet(item: $editingField) { field in
        EditFieldView(field: field) { updatedField in
          if let index = localFields.firstIndex(where: { $0.id == field.id }) {
            localFields[index] = updatedField
          }
        }
      }
    }
  }
}

#Preview(traits: .landscapeRight) {
  FoundationModelsPlayground()
    .environment(FoundationModelsService.shared)
}
