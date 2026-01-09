//
//  FoundationModelsPlayground.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import SwiftUI
import FoundationModels
import HighlightSwift

struct FoundationModelsPlayground: View {
  let highlight: Highlight
  
  init(highlight: Highlight = Highlight()) {
    self.highlight = highlight
  }
  
  @State private var userInput: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""
  @State private var generationMode: GenerationMode = .stream
  
  @State private var swiftCodeOutput: String?
  
  // Generation options
  @State private var temperature: Double = 0.5
  @State private var maxTokens: Int = 2000
  
  enum GenerationMode {
    case stream
    case respondTo
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
    
    // Calls the model to generate a response
    
    """
    let callPrefix = generationMode == .stream
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
    
    let prefex = generationMode == .stream
    ? "for try await content in response {\n    print(content.content)\n}"
    : "print(response.content)"
    
    return header + callPrefix + body + prefex
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
              Text("Generation Options")
                .font(.headline)
              
              Slider(value: $temperature, in: 0...1, step: 0.1) {
                Text("Temperature: \(String(format: "%.1f", temperature))")
              } minimumValueLabel: {
                Text("0.0")
              } maximumValueLabel: {
                Text("1.0")
              }
              
              Slider(value: Binding(
                get: { Double(maxTokens) },
                set: { maxTokens = Int($0) }
              ), in: 10...4090) {
                Text("Max Tokens: \(maxTokens)")
              } minimumValueLabel: {
                Text("10")
              } maximumValueLabel: {
                Text("4090")
              }
              
              Picker("Generation Mode", selection: $generationMode) {
                Text("Stream").tag(GenerationMode.stream)
                Text("Respond To").tag(GenerationMode.respondTo)
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
                .symbolEffect(.breathe, isActive: generationStatus == .generating)
                .symbolRenderingMode(.multicolor)
                .symbolColorRenderingMode(.gradient)
              
              Text("Model Output")
                .font(.title2).bold()
            }
            
            Text(generationStatus.modelStatusText)
              .font(.subheadline)
              .foregroundStyle(.secondary)
            
            if modelOutput != "" {
              Text(modelOutput)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 10))
                .intelligence(in: .rect(cornerRadius: 10))
            }
            
            HStack {
              Text("Swift Code Output")
                .font(.headline)
              
              Spacer()
              
              Button("Copy", systemImage: "document.on.document") {
                UIPasteboard.general.string = fullCode
              }
              .buttonStyle(.glassProminent)
              .labelStyle(.iconOnly)
              .accessibilityLabel("Copy Swift Code to Clipboard")
            }
            VStack {
              CodeViewer(code: fullCode, language: "swift")
            }
            .glassEffect(in: .rect(cornerRadius: 10))
          }
          .padding()
          .frame(width: geometry.size.width * 0.6)
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }
  
  private func generateResponse() async {
    do {
      switch generationMode {
      case .stream:
        let response = foundationModelsService.streamResponse(
          to: userInput,
          options: GenerationOptions(
            temperature: temperature,
            maximumResponseTokens: maxTokens
          )
        )
        
        for try await content in response {
          withAnimation(.bouncy) {
            modelOutput = content.content
          }
        }
      case .respondTo:
        let response = try await foundationModelsService.respond(
          to: userInput,
          options: GenerationOptions(
            temperature: temperature,
            maximumResponseTokens: maxTokens
          )
        )
        
        withAnimation(.bouncy) {
          modelOutput = response.content
        }
      }
    } catch {
      print("Unexpected error: \(error)")
      modelOutput = "An unexpected error occurred: \(error.localizedDescription)"
    }
  }
}

