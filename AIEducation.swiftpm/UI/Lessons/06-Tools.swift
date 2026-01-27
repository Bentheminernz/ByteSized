//
//  06-Tools.swift
//  AIEducation
//
//  Created by Ben Lawrence on 09/12/2025.
//

import FoundationModels
import SwiftUI

struct Tools1: View {
  var body: some View {
    VStack {
      Text(
        "Well yeah, it sounds weird but just like humans need tools to extend their abilities, AI models also benefit from specialized tools to enhance their performance and capabilities."
      )
      .font(.title.bold())

      Text(
        """
        For example, a common issue with LLMs is that their training data only goes up to a certain date, meaning they can't provide real-time information or updates. To solve this, why don't we just give them access to the internet?
        They're not also very good at being personal assistants on their own, so what if we gave it access to your calendar and contacts?
        This is what tools allow us to do, it transforms LLMs from just being text generators to being powerful assistants that can perform a wide range of tasks.

        Heads up! The following lessons will provide examples of LLMs doing just this, the app will request permissions to access your calendar and contacts in order for the LLM to access that data. This is all processed on device and no data leaves your device.
        """
      )
      .foregroundStyle(.secondary)
    }
    .padding()
  }
}

struct Tools2: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  @State private var modelResponse: String = ""

  let session = FoundationModelSession.custom("ToolsExampleSession")
  let prompt =
    "What's my next calendar event? And what is the weather like there currently? If anyone in my contacts is attending, get their relevant contact details for me."

  var body: some View {
    VStack {
      Text("In this example, the model has been asked \"\(prompt)\"")
        .font(.headline)

      Text(
        "If provided access and there are relevant events/contacts, it should be able to provide a detailed response."
      )
      .foregroundStyle(.secondary)

      Text(.init(modelResponse))
        .padding()
        .glassEffect(in: .rect(cornerRadius: 8))
        .intelligence(in: .rect(cornerRadius: 8))
    }
    .task {
      do {
        try await generateResponse()
      } catch {
        modelResponse = "Error: \(error.localizedDescription)"
      }
    }
    .onAppear {
      foundationModelsService.createSession(
        for: session,
        tools: [WeatherTool(), CalendarTool(), ContactsTool()]
      )
    }
  }

  private func generateResponse() async throws {
    let response = foundationModelsService.streamResponse(from: session) {
      prompt
    }

    for try await chunk in response {
      withAnimation(.bouncy) {
        modelResponse = chunk.content
      }
    }
  }
}

struct Tools3: View {
  let grid = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]

  var body: some View {
    VStack {
      Text(
        "How do tools work with AI models?"
      )
      .font(.title.bold())
      .padding(.bottom)

      LazyVGrid(columns: grid, alignment: .leading, spacing: 16) {
        StepView(1, title: "The Model Decides When Tools Are Needed") {
          """
          When you give a model a prompt, it doesn't automatically use every tool provided.
          Instead, it'll evaluate your request and determine if any tools can help it generate a better informed response.
          Think of it like asking a friend for help—they'll decide if they need to look something up or use a calculator based on what you ask.
          """
        }

        StepView(2, title: "Tool Calling Happens Multiple Times") {
          """
          The model doesn't just call one tool and stop, it can make multiple tool calls in sequence as it collects the information it needs.
          It's like solving a puzzle, the model might check your calendar first, then fetch the weather data for that location, and the contact details for attendees.
          Each call builds on the previous one, until the model has enough information to provide a complete response.
          """
        }

        StepView(3, title: "Tools Are Defined By Their Purpose, Not Their Code")
        {
          """
          When you create a tool, you're giving the model a clear description of what it does and what information it needs to work. 
          For example, a weather tool might need to know which city you're asking about. The model reads these descriptions and figures out the right details to provide - like extracting "Boston" from your question "What's the weather in Boston?" 
          Your tool does its job with those details, and sends back what it found in plain, readable text.
          """
        }

        StepView(4, title: "The Model Interprets Tool Results and Keeps Going")
        {
          """
          After a tool returns its result, the model doesn't just pass it along to you—it reads and understands what came back.
          It might realize it needs more information and call another tool, or it might have everything it needs to craft a final answer.
          Think of it like a researcher gathering sources: they don't just collect papers and hand them to you, they read through them, connect the dots, and write up their findings in a way that actually answers your question.
          """
        }
      }
    }
    .padding()
  }

  @ViewBuilder
  func StepView(
    _ number: Int,
    title: String,
    description: () -> String
  ) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Text("\(number)")
        .font(.headline)
        .frame(width: 30, height: 30)
        .background(Circle().fill(Color.blue.opacity(0.2).gradient))

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)

        Text(description())
          .foregroundStyle(.secondary)
      }
    }
  }
}

struct Tools4: View {
  let code = """
    import FoundationModels

    struct GetWeatherTool: Tool {
      // A unique name for the tool
      let name: String = "GetWeather"
      
      // A natural language description of when and how to use the tool.
      let description: String = "Get the current weather for a given location."
      
      // Arguments the LLM will provide to the tool
      @Generable
      struct Arguments {
        @Guide(description: "The city to get weather information for")
        var city: String
      }
      
      
      // The function the LLM will call when it wants to use the tool
      func call(arguments: Arguments) async throws -> String {
        let temperature = Int.random(in: -10...35)
        
        // Returns the result of the call in natural language
        let result = \"""
          The forecast for \\(arguments.city) is \\(temperature)°C
          \"""
        return result
      }
    }

    """

  var body: some View {
    VStack {
      Text("Well then let's see how it works!")
        .font(.title.bold())

      Text(
        "Using Apples Foundation Models frame, it is incredibly easy to write tools for the LLM to use."
      )
      .foregroundStyle(.secondary)
      
      CodeViewer(code: code, language: .swift)
    }
    .padding()
  }
}

struct MasterPromptEngineering1: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  let session1: FoundationModelSession = .custom("MasterPromptEngineering1")
  let session2: FoundationModelSession = .custom("MasterPromptEngineering2")

  @State private var poorOutput: String = ""
  @State private var goodOutput: String = ""

  var body: some View {
    VStack {
      Text(
        "Prompt engineering is the art of crafting effective prompts to guide AI models in generating desired outputs. Mastering this skill allows you to leverage AI capabilities more efficiently. It can be the difference between getting a vague response and a highly relevant one."
      )
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
      foundationModelsService.createSession(
        for: session1,
        instructions: """
          When producing your output avoid using #'s for markdown titles.
          """
      )

      foundationModelsService.createSession(
        for: session2,
        instructions: """
          You are an expert dog trainer and pet care advisor specializing in apartment living. When producing your output avoid using #'s for markdown titles.
          """
      )
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
  private let sessionOne = FoundationModelSession.custom(
    "PromptEngineeringExample1"
  )
  private let sessionTwo = FoundationModelSession.custom(
    "PromptEngineeringExample2"
  )

  @State private var promptOne: String = ""
  @State private var promptTwo: String = ""
  @State private var outputOne: String = ""
  @State private var outputTwo: String = ""

  var body: some View {
    VStack(spacing: 16) {
      generatorView(
        title: "Generator 1",
        prompt: $promptOne,
        output: outputOne,
        status: foundationModelsService.status(for: sessionOne)
      ) {
        Task {
          await generateResponse(
            for: sessionOne,
            prompt: promptOne,
            setOutput: { outputOne = $0 }
          )
        }
      }

      generatorView(
        title: "Generator 2",
        prompt: $promptTwo,
        output: outputTwo,
        status: foundationModelsService.status(for: sessionTwo)
      ) {
        Task {
          await generateResponse(
            for: sessionTwo,
            prompt: promptTwo,
            setOutput: { outputTwo = $0 }
          )
        }
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
  private func generatorView(
    title: String,
    prompt: Binding<String>,
    output: String,
    status: GenerationState,
    action: @escaping () -> Void
  ) -> some View {
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

  private func generateResponse(
    for session: FoundationModelSession,
    prompt: String,
    setOutput: @escaping (String) -> Void
  ) async {
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

