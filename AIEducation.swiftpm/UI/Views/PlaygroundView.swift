//
//  PlaygroundView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import SwiftUI
import FoundationModels

struct PlaygroundView: View {
  let session: LanguageModelSession
  
  init(session: LanguageModelSession = LanguageModelSession()) {
    self.session = session
  }
  
  @State private var generationOptions: GenerationOptions = GenerationOptions()
  @State private var userInput: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""
  @State private var generationStatus: GenerationState = .idle
  
  enum GenerationState {
    case idle
    case requested
    case generating
    case completed
  }
  
  var modelStatusText: String {
    switch generationStatus {
    case .idle: return ""
    case .requested: return "Preparing..."
    case .generating: return "Generating..."
    case .completed: return "Completed"
    }
  }
  
  var body: some View {
    VStack(spacing: 24) {
      Slider(
        value: Binding<Double>(
          get: { generationOptions.temperature ?? 0.5 },
          set: { generationOptions.temperature = $0 }
        ),
        in: 0.0...1.0,
        step: 0.1
      ) {
        Text("Temperature: \(String(format: "%.1f", generationOptions.temperature ?? 0.5))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }
      
      Slider(
        value: Binding<Double>(
          get: { Double(generationOptions.maximumResponseTokens ?? 1) },
          set: { generationOptions.maximumResponseTokens = Int($0) }
        ),
        in: 1...1000,
        step: 1
      ) {
        Text("Max Response Tokens: \(generationOptions.maximumResponseTokens ?? 1)")
      } minimumValueLabel: {
        Text("1")
      } maximumValueLabel: {
        Text("1000")
      }
            
      TextField("Enter your prompt here", text: $userInput)
        .padding()
        .glassEffect(.clear.interactive(), in: .capsule)
      
      Button("Generate") {
        Task { await generateResponse() }
      }
      .buttonStyle(.borderedProminent)
      
      if !modelOutput.isEmpty || !modelStatusText.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          if !modelStatusText.isEmpty {
            Text(modelStatusText)
              .font(.caption)
              .foregroundColor(.secondary)
          }
          
          ScrollView {
            Text(modelOutput)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 12))
        .intelligence(shape: .rect(cornerRadius: 12))
      }
      
      Spacer()
    }
    .padding()
  }
  
  private func generateResponse() async {
    generationStatus = .requested
    do {
      let response = session.streamResponse(
        to: userInput,
        options: generationOptions
      )
      generationStatus = .generating
      
      for try await content in response {
        withAnimation(.bouncy) {
          modelOutput = content.content
        }
      }
      generationStatus = .completed
    } catch {
      print("Error during generation: \(error)")
      generationStatus = .completed
    }
  }
}
