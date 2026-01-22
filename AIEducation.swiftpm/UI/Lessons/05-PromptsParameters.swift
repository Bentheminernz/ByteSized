//
//  05-PromptsParameters.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import FoundationModels
import SwiftUI

// MARK: - WIP

struct PromptsAndParameters1: View {
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Text("Many different factors go into affecting the quality of the output from an AI model.")
          .font(.title.bold())
        
        Text("One such factor is the prompt itself, the input text you provide to the model. Crafting effective prompts is an art form in itself, often referred to as 'prompt engineering'.")
          .foregroundStyle(.secondary)
        
        Text("Another important factor is the parameters used during generation. Parameters such as temperature and max tokens can significantly influence the creativity, coherence, and length of the generated output.")
          .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .padding()
  }
}

struct PromptsAndParameters2: View {
  @State private var temperature: Double = 0.5
  @State private var prompt: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""

  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session: FoundationModelSession = .custom("PromptsAndParameters2")

  var body: some View {
    VStack {
      Text("Temperature is used to increase or decrease the randomness of the output.")
        .font(.title.bold())
      
      Text("Lower temperatures (e.g., 0.2) make the output more focused and deterministic, while higher temperatures (e.g., 0.8) introduce more randomness and creativity. In the demo below, you can adjust the temperature slider to see how it affects the generated response.")
        .foregroundStyle(.secondary)
      
      Text("Temperature: \(String(format: "%.1f", temperature))")
        .contentTransition(.numericText(value: temperature))
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }
      
      Button("Regenerate Response") {
//        modelOutput = ""P00hb3a
        Task {
          await generateResponse()
        }
      }
      .buttonStyle(.glassProminent)

      Text(prompt)

      if let status = foundationModelsService.statuses[session]?.modelStatusText
      {
        Text(status)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }

      Text(modelOutput)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 10))
        .intelligence(in: .rect(cornerRadius: 10))
    }
    .padding()
    .animation(.bouncy, value: temperature)
    .onChange(of: temperature) {
      if foundationModelsService.statuses[session] != .generating
        && foundationModelsService.statuses[session] != .requested
      {
//        modelOutput = ""
        Task {
          await generateResponse()
        }
      }
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
    .task {
      await generateResponse()
    }
  }

  private func generateResponse() async {
    do {
      let options: GenerationOptions = GenerationOptions(
        temperature: temperature,
        maximumResponseTokens: 150
      )

      let response = foundationModelsService.streamResponse(
        from: session,
        options: options
      ) {
        prompt
      }

      for try await content in response {
        withAnimation(.bouncy) {
          modelOutput = content.content
        }
      }
      foundationModelsService.completeStream(for: session)
    } catch {
      modelOutput = "Failed to generate response: \(error.localizedDescription)"
    }
  }
}
