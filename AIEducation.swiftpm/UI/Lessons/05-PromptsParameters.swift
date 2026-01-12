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
    VStack {
      Text(
        "The output from your AI model differs severely based on the prompts and parameters you provide. Experiment with different prompts and parameters to see how the output changes."
      )
      .padding()

    }
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
      Text("Temperature: \(String(format: "%.1f", temperature))")
        .contentTransition(.numericText(value: temperature))
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }

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
    }
    .padding()
    .animation(.bouncy, value: temperature)
    .onChange(of: temperature) {
      if foundationModelsService.statuses[session] != .generating
        && foundationModelsService.statuses[session] != .requested
      {
        modelOutput = ""
        Task {
          await generateResponse()
        }
      }
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
