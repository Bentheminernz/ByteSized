//
//  06-MasterPromptEngineering.swift
//  AIEducation
//
//  Created by Ben Lawrence on 09/12/2025.
//

import SwiftUI
import FoundationModels

struct MasterPromptEngineering1: View {
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
  }
  
  private func generateResponses() async {
    do {
      let session1 = LanguageModelSession()
      
      let poorPrompt = "write very about dogs in apartments"
      let poorResponse = session1.streamResponse(to: poorPrompt)
      for try await content in poorResponse {
        withAnimation(.bouncy) {
          poorOutput = content.content
        }
      }
      
      let session2 = LanguageModelSession()
      let goodPrompt = """
      write a guide for first-time dog owners who live in apartments. Can you explain the top 5 factors to consider when choosing a dog breed for apartment living? For each factor, include:

      Why it matters in an apartment setting
      A specific example of a breed that does well/poorly with this factor
      One practical tip for managing this aspect
      """
      let goodResponse = session2.streamResponse(to: goodPrompt)
      for try await content in goodResponse {
        withAnimation(.bouncy) {
          goodOutput = content.content
        }
      }
    } catch {
      poorOutput = "Error: \(error.localizedDescription)"
      goodOutput = "Error: \(error.localizedDescription)"
    }
  }
}

struct MasterPromptEngineering2: View {
  enum GeneratorID: Int, CaseIterable { case one = 0, two = 1 }
  
  struct GeneratorState {
    var prompt: String = ""
    var output: String = ""
    var status: GenerationState = .idle
  }
  
  @State private var generators: [GeneratorState] = [
    GeneratorState(), GeneratorState()
  ]
  
  var body: some View {
    VStack(spacing: 16) {
      ForEach(GeneratorID.allCases, id: \.self) { id in
        let idx = id.rawValue
        VStack(alignment: .leading, spacing: 8) {
          Text("Generator \(idx + 1)")
            .font(.headline)
          
          TextField("Enter your prompt here", text: $generators[idx].prompt)
            .padding()
            .glassEffect(.regular.interactive(), in: .capsule)
            .onSubmit {
              Task {
                await generateResponse(for: id)
              }
            }
          
          Button("Generate Response") {
            Task {
              await generateResponse(for: id)
            }
          }
          .disabled(generators[idx].prompt.isEmpty || generators[idx].status == .generating)
          
          Text("Status: \(generators[idx].status.modelStatusText)")
            .font(.subheadline)
            .foregroundColor(.secondary)
          
          if !generators[idx].output.isEmpty {
            Text("Output:")
              .font(.subheadline)
              .bold()
            Text(generators[idx].output)
              .padding()
              .glassEffect(in: .rect(cornerRadius: 8))
              .intelligence(in: .rect(cornerRadius: 8))
          }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
      }
    }
    .padding()
  }
  
  private func generateResponse(for id: GeneratorID) async {
    let idx = id.rawValue
    generators[idx].status = .requested
    generators[idx].output = ""
    
    generators[idx].status = .generating
    let session = LanguageModelSession()
    
    do {
      let text = try await session.respond(to: generators[idx].prompt)
      withAnimation(.bouncy) {
        generators[idx].output = text.content
      }
      generators[idx].status = .completed
    } catch {
      generators[idx].status = .completed
      generators[idx].output = "Error: \(error.localizedDescription)"
    }
  }
}

