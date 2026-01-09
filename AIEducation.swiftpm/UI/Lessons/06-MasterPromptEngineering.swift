//
//  06-MasterPromptEngineering.swift
//  AIEducation
//
//  Created by Ben Lawrence on 09/12/2025.
//

import SwiftUI
import FoundationModels

struct MasterPromptEngineering1: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session1: FoundationModelSession = .custom("MasterPromptEngineering1")
  let session2: FoundationModelSession = .custom("MasterPromptEngineering2")
  
  @State private var poorOutput: String = ""
  @State private var goodOutput: String = ""
  
  var body: some View {
    VStack {
      Text("Prompt engineering is the art of crafting effective prompts to guide AI models in generating desired outputs. Mastering this skill allows you to leverage AI capabilities more efficiently. It can be the difference between getting a vague response and a highly relevant one.")
        .padding(.bottom)
      
      HStack {
        VStack(alignment: .leading) {
          Text("Poorly Crafted Prompt")
            .font(.headline)
          
          ScrollView {
            Text(.init(poorOutput))
          }
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 8))
          .intelligence(in: .rect(cornerRadius: 8))
        }
        
        Divider()
        
        VStack(alignment: .leading) {
          Text("Well Crafted Prompt")
            .font(.headline)
          
          ScrollView {
            Text(.init(goodOutput))
          }
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 8))
          .intelligence(in: .rect(cornerRadius: 8))
        }
      }
    }
    .task {
      await generateResponses()
    }
    .onAppear {
      foundationModelsService.createSession(for: session1, instructions: """
      When producing your output avoid using #'s for markdown titles.
      """)
      
      foundationModelsService.createSession(for: session2, instructions: """
      You are an expert dog trainer and pet care advisor specializing in apartment living. When producing your output avoid using #'s for markdown titles.
      """)
    }
    .onDisappear {
      foundationModelsService.clearSession(for: [session1, session2])
    }
  }
  
  private func generateResponses() async {
    do {
      let poorResponse = foundationModelsService.streamResponse(
        from: session1,
      ) {
        "write about dogs in apartments"
      }
      
      for try await content in poorResponse {
        withAnimation(.bouncy) {
          poorOutput = content.content
        }
      }
      foundationModelsService.completeStream(for: session1)
      
      let goodResponse = foundationModelsService.streamResponse(
        from: session2,
      ) {
        """
        write a guide for first-time dog owners who live in apartments. Can you explain the top 5 factors to consider when choosing a dog breed for apartment living? For each factor, include:
        
        Why it matters in an apartment setting
        A specific example of a breed that does well/poorly with this factor
        One practical tip for managing this aspect
        """
      }
      
      for try await content in goodResponse {
        withAnimation(.bouncy) {
          goodOutput = content.content
        }
      }
      foundationModelsService.completeStream(for: session2)
    } catch {
      poorOutput = "Error: \(error.localizedDescription)"
      goodOutput = "Error: \(error.localizedDescription)"
    }
  }
}

struct MasterPromptEngineering2: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  private let sessionOne = FoundationModelSession.custom("PromptEngineeringExample1")
  private let sessionTwo = FoundationModelSession.custom("PromptEngineeringExample2")

  @State private var promptOne: String = ""
  @State private var promptTwo: String = ""
  @State private var outputOne: String = ""
  @State private var outputTwo: String = ""

  var body: some View {
    VStack(spacing: 16) {
      generatorView(title: "Generator 1",
                    prompt: $promptOne,
                    output: outputOne,
                    status: foundationModelsService.status(for: sessionOne)) {
        Task { await generateResponse(for: sessionOne, prompt: promptOne, setOutput: { outputOne = $0 }) }
      }

      generatorView(title: "Generator 2",
                    prompt: $promptTwo,
                    output: outputTwo,
                    status: foundationModelsService.status(for: sessionTwo)) {
        Task { await generateResponse(for: sessionTwo, prompt: promptTwo, setOutput: { outputTwo = $0 }) }
      }
    }
    .padding()
    .onAppear {
      foundationModelsService.createSession(for: [sessionOne, sessionTwo])
    }
    .onDisappear {
      foundationModelsService.clearSession(for: [sessionOne, sessionTwo])
    }
  }

  @ViewBuilder
  private func generatorView(title: String,
                             prompt: Binding<String>,
                             output: String,
                             status: GenerationState,
                             action: @escaping () -> Void) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      TextField("Enter your prompt here", text: prompt)
        .padding()
        .glassEffect(.regular.interactive(), in: .capsule)
        .onSubmit { action() }

      Button("Generate Response", action: action)
        .disabled(prompt.wrappedValue.isEmpty || status == .generating)

      Text("Status: \(status.modelStatusText)")
        .font(.subheadline)
        .foregroundColor(.secondary)

      if !output.isEmpty {
        Text("Output:")
          .font(.subheadline)
          .bold()
        Text(output)
          .padding()
          .glassEffect(in: .rect(cornerRadius: 8))
          .intelligence(in: .rect(cornerRadius: 8))
      }
    }
    .padding()
    .background(Color.blue.opacity(0.05))
    .cornerRadius(10)
  }

  private func generateResponse(for session: FoundationModelSession,
                                prompt: String,
                                setOutput: @escaping (String) -> Void) async {
    // Clear previous output
    setOutput("")

    do {
      let response = try await foundationModelsService.respond(from: session) {
        prompt
      }
      withAnimation(.bouncy) {
        setOutput(response.content)
      }
    } catch {
      setOutput("Error: \(error.localizedDescription)")
    }
  }
}
