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
    VStack(alignment: .center, spacing: 30) {
      Text("Extending AI with Tools")
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
      
      Text(
        "Just like humans need tools to extend their abilities, AI models also benefit from specialized tools to enhance their performance and capabilities."
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      
      HStack(spacing: 20) {
        VStack(spacing: 12) {
          Image(systemName: "calendar")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.red.gradient)
            .symbolColorRenderingMode(.gradient)
          
          Text("Calendar Access")
            .font(.headline)
          
          Text("Check events and manage schedules on your behalf")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
        
        VStack(spacing: 12) {
          Image(systemName: "network")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.blue.gradient)
            .symbolColorRenderingMode(.gradient)
          
          Text("Internet Access")
            .font(.headline)
          
          Text("Fetch real-time data beyond training cutoff dates")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
        
        VStack(spacing: 12) {
          Image(systemName: "person.text.rectangle")
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .foregroundStyle(.purple.gradient)
            .symbolColorRenderingMode(.gradient)
          
          Text("Contacts Access")
            .font(.headline)
          
          Text("Look up contact details and relevant information")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 280)
      }
      
      Text(
        "Tools transform LLMs from just being text generators to being powerful assistants that can perform a wide range of tasks."
      )
      .font(.title3)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      
      HStack(alignment: .top, spacing: 8) {
        Image(systemName: "info.circle.fill")
          .foregroundStyle(.blue)
        Text(
          "Heads up! The following lab will request permissions to access your calendar and contacts. This is all processed on device and no data leaves your device."
        )
        .font(.caption)
        .foregroundStyle(.secondary)
      }
      .padding(12)
      .glassEffect(.regular, in: .rect(cornerRadius: 8))
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
}

struct Tools2: View {
  @Environment(FoundationModelsService.self) private var foundationModelsService
  @State private var modelResponse: String = ""
  @State private var modelStructuredResponse: EventResponse.PartiallyGenerated? = nil
  @State private var showFakeResponse: Bool = false

  let session = FoundationModelSession.custom("ToolsExampleSession")
  let prompt =
    "What's my next calendar event? And what is the weather like there currently? If anyone in my contacts is attending, get their relevant contact details for me."
  
  var isEventFake: Bool {
    if let contacts = modelStructuredResponse?.contacts, !contacts.isEmpty {
      for contact in contacts {
        if contact.email?.contains("example") == true || contact.phone?.contains("555") == true {
          return true
        }
      }
    }
    return false
  }
  
  @Generable
  struct EventResponse {
    @Guide(description: "The next upcoming calendar event for the user")
    var event: CalendarInfo
    
    @Guide(description: "The current weather conditions for the location of the event, if location information is available from the calendar event")
    var weather: WeatherInfo
    
    @Guide(description: "Relevant contact details for any attendees of the event that are in the user's contacts, if any information about attendees is available from the calendar event")
    var contacts: [ContactInfo]?
    
    @Generable
    struct CalendarInfo {
      var title: String
      
      @Guide(description: "The date of the event in a human readable format. For example, 'Sunday, February 1st, 2026'")
      var date: String
      var duration: TimeInterval
      var location: String?
      var notes: String?
    }
    
    @Generable
    struct WeatherInfo {
      @Guide(description: "The current conditions in the city, sunny, cloudy, raining etc")
      var conditions: String
      
      var temperature: Int
      var windSpeed: Int
      var humidity: Int
    }
    
    @Generable
    struct ContactInfo {
      var name: String
      var phone: String?
      var email: String?
    }
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        VStack(spacing: 12) {
          HStack {
            Image(systemName: "wrench.and.screwdriver.fill")
              .font(.largeTitle)
              .foregroundStyle(.blue)
              .symbolColorRenderingMode(.gradient)
            
            Text("Tools in Action")
              .font(.largeTitle.bold())
          }
          
          Text("Watch how the AI uses multiple tools to answer a complex question")
            .font(.title3)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "text.bubble.fill")
              .foregroundStyle(.blue)
            Text("The Question:")
              .font(.headline)
          }
          
          Text("\"\(prompt)\"")
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(in: .rect(cornerRadius: 10))
        }
        
        VStack(alignment: .leading, spacing: 12) {
          HStack {
            Image(systemName: "sparkles")
              .foregroundStyle(.yellow)
            Text("AI Response:")
              .font(.headline)
          }
          
          if modelStructuredResponse != nil {
            ScrollView {
              if let response = modelStructuredResponse {
                VStack(alignment: .leading, spacing: 16) {
                  if isEventFake {
                    Text("The AI hit a snag with its tools, so here's a preview of what the response would look like if everything worked correctly.")
                      .font(.caption)
                  }
                  
                  if let event = response.event {
                    VStack(alignment: .leading, spacing: 8) {
                      HStack {
                        Image(systemName: "calendar")
                          .foregroundStyle(.blue)
                        Text("Next Calendar Event")
                          .font(.subheadline.bold())
                      }
                      
                      VStack(alignment: .leading, spacing: 4) {
                        if let title = event.title {
                          Text(title)
                            .font(.body.bold())
                        }
                        if let date = event.date {
                          Text(date)
                            .font(.caption)
                        }
                        if let duration = event.duration {
                          Text("Duration: \(Int(duration / 60)) mins")
                            .font(.caption)
                        }
                        if let location = event.location {
                          Text(location)
                            .font(.caption)
                        }
                        if let notes = event.notes {
                          Text("Notes: \(notes)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                      }
                      .padding(.leading, 24)
                    }
                  }
                  
                  if let _ = response.event, let _ = response.weather {
                    Divider()
                  }
                  
                  if let weather = response.weather {
                    VStack(alignment: .leading, spacing: 8) {
                      HStack {
                        Image(systemName: "cloud.sun.fill")
                          .foregroundStyle(.orange)
                        Text("Weather")
                          .font(.subheadline.bold())
                      }
                      
                      VStack(alignment: .leading, spacing: 4) {
                        if let conditions = weather.conditions {
                          Text(conditions.capitalized)
                            .font(.caption)
                        }
                        if let temperature = weather.temperature {
                          Text("Temperature: \(temperature)°C")
                            .font(.caption)
                        }
                        if let windSpeed = weather.windSpeed {
                          Text("Wind Speed: \(windSpeed) km/h")
                            .font(.caption)
                        }
                        if let humidity = weather.humidity {
                          Text("Humidity: \(humidity)%")
                            .font(.caption)
                        }
                      }
                      .padding(.leading, 24)
                    }
                  }
                  
                  if let _ = response.weather, let _ = response.contacts {
                    Divider()
                  } else if let _ = response.event, let _ = response.contacts {
                    Divider()
                  }
                  
                  if let contacts = response.contacts {
                    VStack(alignment: .leading, spacing: 8) {
                      HStack {
                        Image(systemName: "person.text.rectangle.fill")
                          .foregroundStyle(.purple)
                        Text("Contact Details")
                          .font(.subheadline.bold())
                      }
                      
                      VStack(alignment: .leading, spacing: 12) {
                        ForEach(contacts, id: \.name) { contact in
                          VStack(alignment: .leading, spacing: 4) {
                            if let name = contact.name {
                              Text(name)
                                .font(.body.bold())
                            }
                            if let phone = contact.phone {
                              Text("Phone: \(phone)")
                                .font(.caption)
                            }
                            if let email = contact.email {
                              Text("Email: \(email)")
                                .font(.caption)
                            }
                          }
                        }
                      }
                      .padding(.leading, 24)
                    }
                  }
                }
                .padding()
              }
            }
            .frame(minHeight: 200)
            .glassEffect(in: .rect(cornerRadius: 10))
            .intelligence(in: .rect(cornerRadius: 10))
          } else {
            HStack {
              ProgressView()
                .padding(.trailing, 8)
              Text("Calling tools and generating response...")
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .glassEffect(in: .rect(cornerRadius: 10))
          }
        }
        
        HStack(alignment: .top, spacing: 8) {
          Image(systemName: "info.circle.fill")
            .foregroundStyle(.blue)
          Text(
            "The AI automatically decided which tools to use (Calendar, Weather, Contacts) based on the question, called them in sequence, and synthesized the results into a helpful response."
          )
          .font(.caption)
          .foregroundStyle(.secondary)
        }
        .padding(12)
        .glassEffect(.regular, in: .rect(cornerRadius: 8))
      }
      .padding()
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
        instructions: """
            You are a helpful assistant that retrieves calendar events, weather information, and contact details using the provided tools.
            
            Important rules:
            - Try to return actual data retrieved from the tools
            - If the tools return no data or fail, you should generate a realistic fake example response to demonstrate how the system works
            - When generating fake data, ALWAYS set isFakeEvent to true
            - Make fake data realistic and believable (e.g., "Team Meeting" not "Fake Event")
            """,
        tools: [WeatherTool(), CalendarTool(), ContactsTool()],
      )
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
  }

  private func generateResponse() async throws {
    let response = foundationModelsService.streamResponse(from: session, generating: EventResponse.self) {
      prompt + " The current date is: \(Date())."
    }

    for try await chunk in response {
      withAnimation(.bouncy) {
        modelStructuredResponse = chunk.content
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
