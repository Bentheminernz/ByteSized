//
//  05-PromptsParameters.swift
//  ByteSized
//
//  Created by Ben Lawrence on 06/11/2025.
//

import FoundationModels
import SwiftUI

// MARK: - Complete
struct PromptsAndParameters1: View {
  var body: some View {
    VStack(alignment: .center, spacing: 30) {
      Text("Crafting the Perfect Prompt")
        .font(.largeTitle)
        .bold()
      
      Text(
        "Think of AI like a chef in a restaurant. The better your order (prompt), the better your meal (output)!"
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      
      HStack(spacing: 20) {
        VStack(spacing: 12) {
          Image(systemName: "text.bubble")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundStyle(.blue)
            .symbolColorRenderingMode(.gradient)
          
          Text("The Prompt")
            .font(.headline)
          
          Text(
            "What you tell the AI. Clear instructions get better results!"
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 300)
        
        VStack(spacing: 12) {
          Image(systemName: "slider.horizontal.3")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundStyle(.purple)
            .symbolColorRenderingMode(.gradient)
          
          Text("Parameters")
            .font(.headline)
          
          Text(
            "Settings that control how creative or focused the AI should be."
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 300)
        
        VStack(spacing: 12) {
          Image(systemName: "sparkles")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundStyle(.yellow)
            .symbolColorRenderingMode(.gradient)
          
          Text("Great Output")
            .font(.headline)
          
          Text(
            "When you combine good prompts with the right settings, magic happens!"
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 300)
      }
      
      Text(
        "Let's explore how to write better prompts and adjust parameters to get exactly what you want from AI."
      )
      .font(.body)
      .foregroundStyle(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
}

// MARK: - Slide 2
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
      Text("Good vs. Bad Prompts")
        .font(.largeTitle.bold())
      
      Text(
        "Let's see the difference! Watch how specific details make all the difference."
      )
      .font(.title3)
      .foregroundStyle(.secondary)

      HStack(spacing: 20) {
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.red)
              .font(.title)
            Text("Vague Prompt")
              .font(.title2.bold())
              .foregroundStyle(.red)
          }

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

          VStack(alignment: .leading, spacing: 8) {
            Text("Why is this bad?")
              .font(.headline)
            
            HStack(alignment: .top) {
              Image(systemName: "1.circle.fill")
                .foregroundStyle(.red)
              Text("No clear topic or focus")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "2.circle.fill")
                .foregroundStyle(.red)
              Text("Doesn't specify length")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "3.circle.fill")
                .foregroundStyle(.red)
              Text("Missing the style or format")
            }
          }
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 8))
        }

        Divider()

        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "checkmark.circle.fill")
              .foregroundStyle(.green)
              .font(.title)
            Text("Specific Prompt")
              .font(.title2.bold())
              .foregroundStyle(.green)
          }

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

          VStack(alignment: .leading, spacing: 8) {
            Text("Why is this better?")
              .font(.headline)
            
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("Clear topic: companionship")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("Exact length: 3 paragraphs")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("Specific focus areas listed")
            }
          }
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 8))
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


// MARK: - Slide 3
struct PromptsAndParameters3: View {
  @State private var temperature: Double = 0.5
  @State private var prompt: String = "Hello there! Can you tell me a joke?"

  @State private var oldModelOutput: String = ""
  @State private var modelOutput: String = ""
  @State private var generationCount: Int = 0

  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session: FoundationModelSession = .custom("PromptsAndParameters2")

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        VStack(spacing: 8) {
          HStack {
            Image(systemName: "thermometer.medium")
              .font(.title)
              .foregroundStyle(.orange)
            
            Text("Temperature Control")
              .font(.title.bold())
          }
          
          Text(
            "Think of temperature like a creativity dial. Turn it low for focused answers, or high for wild ideas!"
          )
          .font(.subheadline)
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        
        HStack(spacing: 20) {
          VStack(spacing: 6) {
            Image(systemName: "snowflake")
              .font(.system(size: 30))
              .foregroundStyle(.cyan)
            
            Text("Low Temp")
              .font(.subheadline.bold())
            
            Text("Focused")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 10))
          
          Image(systemName: "arrow.right")
            .font(.title3)
            .foregroundStyle(.secondary)
          
          VStack(spacing: 6) {
            Image(systemName: "flame.fill")
              .font(.system(size: 30))
              .foregroundStyle(.orange)
            
            Text("High Temp")
              .font(.subheadline.bold())
            
            Text("Creative")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 10))
        }
        
        VStack(spacing: 8) {
          HStack(spacing: 12) {
            Image(systemName: "snowflake")
              .foregroundStyle(.cyan)
              .font(.title3)
            
            Slider(value: $temperature, in: 0...1, step: 0.1) {
              Text("Temperature: \(String(format: "%.1f", temperature))")
            }
            .tint(temperatureColor())
            
            Image(systemName: "flame.fill")
              .foregroundStyle(.orange)
              .font(.title3)
            
            VStack(spacing: 2) {
              Text("\(String(format: "%.1f", temperature))")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .contentTransition(.numericText(value: temperature))
              
              Text(temperatureText())
                .font(.caption)
                .foregroundStyle(temperatureColor())
            }
            .frame(width: 120)
            .padding(8)
            .glassEffect(.regular, in: .rect(cornerRadius: 10))
          }
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
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "text.bubble.fill")
              .foregroundStyle(.blue)
            Text("Your Prompt:")
              .font(.headline)
          }
          .padding(.top)
          
          Text("Edit me! Try asking the same question with different temperatures to see how the response changes.")
            .font(.caption)
            .foregroundStyle(.secondary)
          
          TextField("Enter your prompt here", text: $prompt)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
        }
        
        HStack(spacing: 16) {
          VStack(spacing: 8) {
            HStack {
              Image(systemName: "clock.arrow.circlepath")
                .foregroundStyle(.secondary)
              Text("Previous Response")
                .font(.headline)
                .foregroundStyle(.secondary)
            }
            
            ScrollView {
              Text(oldModelOutput.isEmpty ? "No previous response yet" : oldModelOutput)
                .padding()
                .foregroundStyle(oldModelOutput.isEmpty ? .tertiary : .primary)
            }
            .frame(minHeight: 100)
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }
          .opacity(oldModelOutput.isEmpty ? 0.5 : 1)
          
          VStack(spacing: 8) {
            HStack {
              Image(systemName: "sparkles")
                .foregroundStyle(.yellow)
              Text("Current Response")
                .font(.headline)
            }
            
            ScrollView {
              Text(modelOutput.isEmpty ? "Click 'Generate Response' to start!" : modelOutput)
                .padding()
                .foregroundStyle(modelOutput.isEmpty ? .tertiary : .primary)
            }
            .frame(minHeight: 100)
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          }
        }
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "lightbulb.fill")
              .foregroundStyle(.yellow)
            Text("Pro Tip:")
              .font(.headline)
          }
          
          Text(
            "Try generating the same prompt multiple times at different temperatures. See how low temperatures give similar responses while high temperatures create unique, creative variations!"
          )
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 10))
        .padding(.bottom, 12)
      }
      .padding(.horizontal)
      .animation(.bouncy, value: temperature)
      .onChange(of: temperature) { oldValue, newValue in
        if foundationModelsService.statuses[session] != .generating
            && foundationModelsService.statuses[session] != .requested
        {
          Task {
            try? await Task.sleep(for: .milliseconds(300))
            await generateResponse()
          }
        }
      }
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
    .task {
      foundationModelsService.createSession(for: session)
      
      let oldModel = foundationModelsService.getSession(for: .custom("PromptsAndParameters2"), createIfMissing: false)
      if !oldModel.isResponding {
        await generateResponse()
      } else {
        foundationModelsService.clearSession(for: .custom("PromptsAndParameters2"))
        await generateResponse()
      }
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
        if content.content.contains("Attempted to call respond(to:)") {
          
        }
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
  
  private func temperatureColor() -> Color {
    if temperature <= 0.3 {
      return .cyan
    } else if temperature <= 0.7 {
      return .blue
    } else {
      return .orange
    }
  }
}

// MARK: - Slide 4
struct PromptsAndParameters4: View {
  @State private var maxTokens: Double = 50
  @State private var prompt: String = "Tell me about the solar system"
  @State private var modelOutput: String = ""
  
  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session: FoundationModelSession = .custom("PromptsAndParameters4")
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        VStack(spacing: 8) {
          HStack {
            Image(systemName: "text.alignleft")
              .font(.title)
              .foregroundStyle(.green)
            
            Text("Max Tokens")
              .font(.title.bold())
          }
          
          Text("Control How Long the AI's Response Should Be")
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        
        HStack(spacing: 16) {
          VStack(spacing: 6) {
            Image(systemName: "text.word.spacing")
              .font(.system(size: 30))
              .foregroundStyle(.blue)
            
            Text("What are Tokens?")
              .font(.subheadline.bold())
            
            Text("Building blocks of text")
              .multilineTextAlignment(.center)
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 10))
          .frame(maxWidth: .infinity)
          
          VStack(spacing: 6) {
            Image(systemName: "ruler")
              .font(.system(size: 30))
              .foregroundStyle(.purple)
            
            Text("Max Tokens")
              .font(.subheadline.bold())
            
            Text("Limits response length")
              .multilineTextAlignment(.center)
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 10))
          .frame(maxWidth: .infinity)
          
          VStack(spacing: 6) {
            Image(systemName: "scissors")
              .font(.system(size: 30))
              .foregroundStyle(.orange)
            
            Text("Why Limit?")
              .font(.subheadline.bold())
            
            Text("Control costs & brevity")
              .multilineTextAlignment(.center)
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          .padding(12)
          .glassEffect(.regular, in: .rect(cornerRadius: 10))
          .frame(maxWidth: .infinity)
        }
        
        VStack(spacing: 8) {
          HStack(spacing: 12) {
            Text("Short")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(width: 40)
            
            Slider(value: $maxTokens, in: 20...200, step: 10) {
              Text("Max Tokens: \(Int(maxTokens))")
            }
            .tint(.green)

            Text("Long")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(width: 40)
            
            VStack(spacing: 2) {
              Text(String(format: "%.0f", maxTokens))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .contentTransition(.numericText(value: maxTokens))
              
              Text("tokens")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(width: 100)
            .padding(8)
            .glassEffect(.regular, in: .rect(cornerRadius: 10))
          }
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
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "text.bubble.fill")
              .foregroundStyle(.blue)
            Text("Your Prompt:")
              .font(.headline)
          }
          
          Text("Edit me! Try asking the same question with different max token limits to see how the response length changes.")
            .font(.caption)
            .foregroundStyle(.secondary)
          
          TextField("Enter your prompt here", text: $prompt)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
        }
        
        VStack(spacing: 8) {
          HStack {
            Image(systemName: "text.alignleft")
              .foregroundStyle(.green)
            Text("AI Response")
              .font(.headline)
          }
          
          ScrollView {
            Text(modelOutput.isEmpty ? "Adjust the slider and click 'Generate Response' to see how max tokens affects length!" : modelOutput)
              .padding()
              .foregroundStyle(modelOutput.isEmpty ? .tertiary : .primary)
          }
          .frame(minHeight: 120)
          .glassEffect(in: .rect(cornerRadius: 10))
          .intelligence(in: .rect(cornerRadius: 10))
        }
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundStyle(.orange)
            Text("Notice:")
              .font(.headline)
          }
          
          Text(
            "With fewer tokens, responses might be cut off mid-sentence. With more tokens, you get complete, detailed answers. Try different values to see the difference!"
          )
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 10))
        .padding(.bottom, 12)
      }
      .padding(.horizontal)
      .animation(.bouncy, value: maxTokens)
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
    .task {
      foundationModelsService.createSession(for: session)
    }
    .onChange(of: maxTokens) { oldValue, newValue in
      if foundationModelsService.statuses[session] != .generating
          && foundationModelsService.statuses[session] != .requested
      {
        Task {
          try? await Task.sleep(for: .milliseconds(300))
          await generateResponse()
        }
      }
    }
  }
  
  private func generateResponse() async {
    do {
      let options: GenerationOptions = GenerationOptions(
        temperature: 0.7,
        maximumResponseTokens: Int(maxTokens)
      )
      
      modelOutput = ""
      
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

// MARK: - Slide 5
struct PromptsAndParameters5: View {
  @State private var showingSystemPrompt = false
  @State private var userMessage: String = "What's your favourite food?"
  @State private var modelOutput: String = ""
  @State private var selectedPersonality: Int = 0
  
  let personalities = [
    ("Cowboy", "🤠", "You are a friendly cowboy who speaks in cowboy slang and relates everything to the Wild West."),
    ("Pirate", "🏴‍☠️", "You are a friendly pirate who talks in pirate speak and relates everything to the sea and treasure."),
    ("Mad Scientist", "🔬", "You are a quirky mad scientist who loves experiments and uses scientific jargon in your responses.")
  ]
  
  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session: FoundationModelSession = .custom("PromptsAndParameters5")
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        VStack(spacing: 12) {
          HStack {
            Image(systemName: "person.text.rectangle")
              .font(.largeTitle)
              .foregroundStyle(.purple)
            
            Text("System Instructions")
              .font(.largeTitle.bold())
          }
          
          Text("Give the AI a Personality!")
            .font(.title3)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
          
          Text(
            "System instructions tell the AI how to behave. It's like giving someone a role to play!"
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        
        VStack(spacing: 15) {
          Text("Choose a Personality:")
            .font(.headline)
          
          HStack(spacing: 20) {
            ForEach(0..<personalities.count, id: \.self) { index in
              Button(action: {
                selectedPersonality = index
                modelOutput = ""
              }) {
                VStack(spacing: 8) {
                  Text(personalities[index].1)
                    .font(.system(size: 50))
                  
                  Text(personalities[index].0)
                    .font(.headline)
                    .foregroundStyle(selectedPersonality == index ? .primary : .secondary)
                }
                .padding()
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
                .overlay(
                  RoundedRectangle(cornerRadius: 15)
                    .stroke(selectedPersonality == index ? Color.purple : Color.clear, lineWidth: 3)
                )
              }
              .buttonStyle(.plain)
            }
          }
        }
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "doc.text")
              .foregroundStyle(.purple)
            Text("System Instruction for \(personalities[selectedPersonality].0):")
              .font(.headline)
            
            Spacer()
            
            Button(action: {
              withAnimation(.bouncy) {
                showingSystemPrompt.toggle()
              }
            }) {
              HStack(spacing: 4) {
                Image(systemName: showingSystemPrompt ? "eye.slash.fill" : "eye.fill")
                  .contentTransition(.symbolEffect(.replace))
                Text(showingSystemPrompt ? "Hide" : "Show")
              }
//              .font(.caption)
            }
            .buttonStyle(.bordered)
          }
          
          if showingSystemPrompt {
            Text(personalities[selectedPersonality].2)
              .padding()
              .glassEffect(.regular, in: .rect(cornerRadius: 8))
              .foregroundStyle(.secondary)
              .font(.subheadline)
          }
        }
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "message.fill")
              .foregroundStyle(.blue)
            Text("Your Message:")
              .font(.headline)
          }
          
          TextField("Type your message here", text: $userMessage)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
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
              : "Send Message"
            )
          }
        }
        .buttonStyle(.glassProminent)
        .disabled(
          foundationModelsService.statuses[session] == .generating
          || foundationModelsService.statuses[session] == .requested
        )
        
        VStack(spacing: 8) {
          HStack {
            Text(personalities[selectedPersonality].1)
              .font(.title)
            Text("\(personalities[selectedPersonality].0)'s Response:")
              .font(.headline)
          }
          
          ScrollView {
            Text(modelOutput.isEmpty ? "Select a personality and send a message to see them in action!" : modelOutput)
              .padding()
              .foregroundStyle(modelOutput.isEmpty ? .tertiary : .primary)
          }
          .frame(minHeight: 200)
          .glassEffect(in: .rect(cornerRadius: 10))
          .intelligence(in: .rect(cornerRadius: 10))
        }
        
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Image(systemName: "star.fill")
              .foregroundStyle(.yellow)
            Text("Try This:")
              .font(.headline)
          }
          
          Text(
            "Ask the same question to different personalities and see how their responses change based on their system instructions!"
          )
          .foregroundStyle(.secondary)
          .padding(.bottom, 12)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 10))
      }
      .padding(.horizontal)
      .onDisappear {
        foundationModelsService.clearSession(for: session)
      }
      .onChange(of: selectedPersonality) {
        foundationModelsService.clearSession(for: session)
        foundationModelsService.createSession(for: session, instructions: personalities[selectedPersonality].2)
      }
      .task {
        foundationModelsService.createSession(for: session, instructions: personalities[selectedPersonality].2)
      }
    }
  }
  
  private func generateResponse() async {
    do {
      modelOutput = ""
      
      // Create session with system instructions
      foundationModelsService.clearSession(for: session)
      foundationModelsService.createSession(
        for: session,
        instructions: personalities[selectedPersonality].2
      )
      
      let options: GenerationOptions = GenerationOptions(
        temperature: 0.8,
        maximumResponseTokens: 150
      )
      
      let response = foundationModelsService.streamResponse(
        from: session,
        options: options
      ) {
        userMessage
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


