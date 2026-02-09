//
//  06-Tools.swift
//  AIEducation
//
//  Created by Ben Lawrence on 09/12/2025.
//

import FoundationModels
import SwiftUI

// MARK: -Complete
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

        Heads up! The following lesson will provide examples of LLMs doing just this, the app will request permissions to access your calendar and contacts in order for the LLM to access that data. This is all processed on device and no data leaves your device.
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
  @State private var showFakeResponse: Bool = false

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

      if modelResponse != "" && !showFakeResponse {
        Button(
          "If you didn't get a proper response, click here to see an example."
        ) {
          showFakeResponse = true
        }
      }

      if showFakeResponse {
        Text(
          """
          Your next calendar even is:
          - Meeting with John Appleseed
          - Date and Time: Sunday, February 1st, 2026, 10:00AM - 1:00PM (3h)
          - Location: Te Pae, Christchurch, New Zealand
          - Notes: Fictitious Apple Keynote discussing latest technologies and empowering Kiwi Developers.
          
          The weather in Christchurch is currently 22°C with clear skies and a gentle breeze.
          
          For John Appleseed (A contact who is attending):
          - Phone: (555) 123-4567
          - Email: johnappleseed@example.com
          """
        )
        .padding()
        .glassEffect(in: .rect(cornerRadius: 8))
      }
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
    .onDisappear {
      foundationModelsService.clearSession(for: session)
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
    ScrollView {
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
  let toolCode = """
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

  let callingCode = """
    import FoundationModels

    let instructions = "Help the user with getting weather information"
    let session = LanguageModelSession(tools: [GetWeatherTool()], instructions: instructions)

    let response = try await session.respond(
      to: "What's the weather like in Paris?"
    )

    print(response.content)
    """

  var body: some View {
    VStack {
      Text("Well then let's see how it works!")
        .font(.title.bold())

      Text(
        "Using Apples Foundation Models frame, it is incredibly easy to write tools for the LLM to use."
      )
      .foregroundStyle(.secondary)
      HStack {
        VStack {
          Text(
            "First, you define your tool by conforming to the Tool protocol. You provide a name, description, and the arguments it needs. Then you implement the call function which contains the logic of what the tool does:"
          )
          .foregroundStyle(.secondary)

          ScrollView {
            CodeViewer(code: toolCode, language: .swift)
          }
        }

        Divider()

        VStack {
          Text(
            "Then to call the tool from the LLM, you just create a session with the tool included and make your request as normal:"
          )
          .foregroundStyle(.secondary)

          ScrollView {
            CodeViewer(code: callingCode, language: .swift)
          }
        }
      }
    }
    .padding()
  }
}
