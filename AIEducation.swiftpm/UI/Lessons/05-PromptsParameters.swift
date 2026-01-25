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
        Text(
          "Many different factors go into affecting the quality of the output from an AI model."
        )
        .font(.title.bold())

        Text(
          "One such factor is the prompt itself, the input text you provide to the model. Crafting effective prompts is an art form in itself, often referred to as 'prompt engineering'."
        )
        .foregroundStyle(.secondary)

        Text(
          "Another important factor is the parameters used during generation. Parameters such as temperature and max tokens can significantly influence the creativity, coherence, and length of the generated output."
        )
        .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .padding()
  }
}

struct PromptsAndParameters2: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService

  @State var badPromptOutput: String = ""
  @State var goodPromptOutput: String = ""

  var badPrompt: String = "Write me something interesting about dogs."
  var goodPrompt: String =
    "Write a 3-paragraph informative article explaining why dogs make good companions, focusing on their loyalty, trainability, and emotional benefits."

  let session: FoundationModelSession = .custom("PromptsAndParameters2")

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text(
        "An LLM is like an instrument: better prompts and parameters produce better results. Let's start with crafting a good prompt."
      )
      .font(.title.bold())

      HStack(spacing: 12) {
        //        ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          Text("Bad Prompt")
            .font(.headline)
            .foregroundStyle(.red)

          Text("\"\(badPrompt)\"")
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))

          if !badPromptOutput.isEmpty {
            ScrollView {
              Text(badPromptOutput)
                .padding()
            }
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }

          Text("Now, this seems like a decent prompt, why is it bad?")
            .font(.headline)

          Text(
            "The problem is, it's too vague and unclear. What should it say about dogs? How long do you want it? What style should it be written in?"
          )
          .font(.subheadline)
          .foregroundStyle(.secondary)
        }
        //          .padding()
        //        }

        Divider()

        VStack(alignment: .leading, spacing: 12) {
          Text("Good Prompt")
            .font(.headline)
            .foregroundStyle(.green)

          Text("\"\(goodPrompt)\"")
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))

          if !goodPromptOutput.isEmpty {
            ScrollView {
              Text(goodPromptOutput)
                .padding()
            }
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }

          Text(
            "This prompt is much better because it's specific about the format (3 paragraphs), the purpose (informative), the topic (companionship), and the focus areas (loyalty, trainability, emotional benefits)."
          )
          .font(.subheadline)
          .foregroundStyle(.secondary)
        }
      }
    }
    .onAppear {
      foundationModelsService.createSession(for: session)
    }
    .task {
      try? await generateOutputs()
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
  }

  func generateOutputs() async throws {
    do {
      let badStream = foundationModelsService.streamResponse(
        from: session,
      ) {
        badPrompt
      }
      for try await content in badStream {
        withAnimation(.bouncy) {
          badPromptOutput = content.content
        }
      }
      foundationModelsService.completeStream(for: session)
      foundationModelsService.clearSession(for: session)

      let goodStream = foundationModelsService.streamResponse(
        from: session,
      ) {
        goodPrompt
      }
      for try await content in goodStream {
        withAnimation(.bouncy) {
          goodPromptOutput = content.content
        }
      }
      foundationModelsService.completeStream(for: session)
    } catch {
      print("Failed to generate content: \(error)")
    }
  }
}

struct PromptsAndParameters3: View {
  @State private var temperature: Double = 0.5
  @State private var prompt: String = "Hello there! Can you tell me a joke?"

  @State private var oldModelOutput: String = ""
  @State private var modelOutput: String = ""
  @State private var generationCount: Int = 0

  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session: FoundationModelSession = .custom("PromptsAndParameters2")

  var body: some View {
    VStack {
      Text(
        "Temperature is used to increase or decrease the randomness of the output."
      )
      .font(.title.bold())

      Text(
        "Lower temperatures (e.g., 0.2) make the output more focused and deterministic, while higher temperatures (e.g., 0.8) introduce more randomness and creativity. In the demo below, you can adjust the temperature slider to see how it affects the generated response."
      )
      .foregroundStyle(.secondary)

      Text(
        "Temperature: \(String(format: "%.1f", temperature)) - \(temperatureText())"
      )
      .contentTransition(.numericText(value: temperature))
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }

      Button(action: {
        Task {
          await generateResponse()
        }
      }) {
        HStack {
          if foundationModelsService.statuses[session] == .generating
            || foundationModelsService.statuses[session] == .requested
          {
            ProgressView()
          }
          Text(
            (foundationModelsService.statuses[session] == .generating
             || foundationModelsService.statuses[session] == .requested)
            ? "Generating..."
            : "Generate Response"
          )
        }
      }
      .buttonStyle(.glassProminent)
      .disabled(
        foundationModelsService.statuses[session] == .generating
        || foundationModelsService.statuses[session] == .requested
      )

      VStack(alignment: .leading) {
        Text("Prompt:")
          .font(.headline)
          .padding(.top)

        TextField("Enter your prompt here", text: $prompt)
          .padding()
          .glassEffect(in: .capsule)
      }

      HStack(spacing: 16) {
        VStack {
          Text("Previous Response")
            .foregroundStyle(.secondary)

          Text(oldModelOutput)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
        }
        .opacity(oldModelOutput.isEmpty ? 0 : 1)

        VStack {
          Text("Current Response")
            .foregroundStyle(.secondary)

          Text(modelOutput)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
        }
      }

      Text(
        "You should notice that as you adjust the temperature slider, the nature of the generated response changes. Lower temperatures yield more predictable and coherent responses, while higher temperatures produce more diverse and creative outputs."
      )
      .foregroundStyle(.secondary)
      .padding(.top, 12)
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
      foundationModelsService.createSession(for: session)
      await generateResponse()
    }
  }

  private func generateResponse() async {
    do {
      generationCount += 1
      let old = modelOutput
      let options: GenerationOptions = GenerationOptions(
        temperature: temperature,
        maximumResponseTokens: 150
      )

      if generationCount % 5 == 0 {
        foundationModelsService.clearSession(for: session)
        foundationModelsService.createSession(for: session)
        print("Recreated session to avoid context overload.")
      }

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
      withAnimation(.bouncy) {
        oldModelOutput = old
      }
      foundationModelsService.completeStream(for: session)
    } catch {
      modelOutput = "Failed to generate response: \(error.localizedDescription)"
    }
  }

  private func temperatureText() -> String {
    if temperature <= 0.3 {
      return "Low (Focused)"
    } else if temperature <= 0.7 {
      return "Medium (Balanced)"
    } else {
      return "High (Creative)"
    }
  }
}

