//
//  05-PromptsParameters.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI
import FoundationModels

// MARK: - WIP

struct PromptsAndParameters1: View {
  var body: some View {
    
  }
}

struct PromptsAndParameters2: View {
  @State private var temperature: Double = 0.5
  @State private var userInput: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""
  @State private var generationStatus: GenerationState = .idle
  
  var body: some View {
    VStack {
      Text("Temperature: \(String(format: "%.1f", temperature))")
        .contentTransition(.numericText(value: temperature))
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }
      
      TextField("Enter your prompt here", text: $userInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Button("Generate Response") {
        Task {
          await generateResponse()
        }
      }
      
      Text(generationStatus.modelStatusText)
        .font(.subheadline)
        .foregroundStyle(.secondary)

      Text(modelOutput)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 10))
    }
    .padding()
    .animation(.bouncy, value: temperature)
    .onChange(of: temperature) {
      if generationStatus != .generating && generationStatus != .requested {
        modelOutput = ""
        Task {
          await generateResponse()
        }
      }
    }
  }
  
  private func generateResponse() async {
    generationStatus = .requested
    do {
      let session = LanguageModelSession()
      let options: GenerationOptions = GenerationOptions(
        temperature: temperature,
        maximumResponseTokens: 150
      )
      
      let response = session.streamResponse(
        to: userInput,
        options: options
      )
      generationStatus = .generating
      
      for try await content in response {
        withAnimation(.bouncy) {
          modelOutput = content.content
        }
      }
      generationStatus = .completed
    } catch {
      modelOutput = "Failed to generate response: \(error.localizedDescription)"
      generationStatus = .completed
    }
  }
}
