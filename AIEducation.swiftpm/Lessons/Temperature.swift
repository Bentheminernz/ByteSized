//
//  Temperature.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI
import FoundationModels

struct TemperatureLesson: View {
  @State private var temperature: Double = 0.5
  @State private var userInput: String = ""
  @State private var modelOutput: String = "Model output will appear here."
  
  let session: LanguageModelSession
  
  init(session: LanguageModelSession = LanguageModelSession()) {
    self.session = session
  }
  
  var body: some View {
    VStack {
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      }
      
      TextField("Enter your prompt here", text: $userInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Button("Generate Response") {
        Task {
          await generateResponse()
        }
      }
      
      Text(modelOutput)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 10))
    }
    .onAppear {
      session.prewarm()
    }
  }
  
  private func generateResponse() async {
    let options: GenerationOptions = GenerationOptions(
      temperature: temperature
    )
    
    let response = try? await session.respond(
      to: userInput,
      options: options
    )
    
    if let response {
      modelOutput = response.content
    } else {
      modelOutput = "Failed to generate response."
    }
  }
}
