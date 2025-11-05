import SwiftUI
import FoundationModels

struct ContentView: View {
  @State var userInput: String = ""
  @State var modelOutput: String = "Model output will appear here."
  @State var temperature: Double = 0.5
  
  var body: some View {
    VStack {
      Text("The temperature setting controls the randomness of the model's output. A higher temperature results in more diverse and creative responses, while a lower temperature produces more focused and deterministic outputs. When the temperature is set to 0, the output will be the most predictable and repetitive, often favoring the most likely next words. As the temperature increases towards 1, the model takes more risks, leading to varied and imaginative responses.")
        .padding()
      
      TextField("Enter your prompt here", text: $userInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Slider(value: $temperature, in: 0...1, step: 0.1) {
        Text("Temperature: \(String(format: "%.1f", temperature))")
      }
      
      Button("Generate Response") {
        Task {
          await generateResponse()
        }
      }
      
      Text(modelOutput)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 10))
    }
  }
  
  private func generateResponse() async {
    let options: GenerationOptions = GenerationOptions(
      temperature: temperature,
    )
    let session: LanguageModelSession = LanguageModelSession(
      model: .default,
      instructions: "Respond to the user's prompt appropriately."
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
