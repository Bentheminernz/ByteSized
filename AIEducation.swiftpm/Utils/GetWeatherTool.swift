//
//  GetWeatherTool.swift
//  ByteSized
//
//  Created by Ben Lawrence on 28/01/2026.
//

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
    // Generates a random temperature for demonstration purposes
    // Use a real weather service, such as WeatherKit, to get actual weather data
    let temperature = Int.random(in: -10...35)

    // Returns the result of the call in natural language
    let result = """
      The forecast for \(arguments.city) is \(temperature)°C
      """
    return result
  }
}

struct Test {
  static func test() async throws {
    let instructions = "Help the user with getting weather information"
    let session = LanguageModelSession(tools: [GetWeatherTool()], instructions: instructions)
    
    let response = try await session.respond(
      to: "What's the weather like in Paris?"
    )
    
    print(response.content)
  }
}
