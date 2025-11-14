//
//  WhatIsAILesson.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import SwiftUI
import FoundationModels

struct WhatIsAILesson1: View {
  var body: some View {
    VStack {
      Text("What is AI?")
        .font(.largeTitle)
        .bold()
        
      Text("When people think of AI (Artificial Intelligence), they often imagine chatbots, virtual assistants, or even robots. But AI is much more than that! And it comes in many different forms.")
        .font(.body)
        
      HStack {
        VStack {
          Image(systemName: "brain")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
          
          Text("Artificial Intelligence")
            .font(.headline)
          
          Text("AI is the broad concept of making computers do things that seem intelligent.")
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 350)
        
        VStack {
          Image(systemName: "cpu")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
          
          Text("Machine Learning")
            .font(.headline)
          
          Text("A subset of AI that focuses on teaching computers to learn from data.")
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 350)
        
        VStack {
          Image(systemName: "network")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
          
          Text("Deep Learning")
            .font(.headline)
          
          Text("A subset of machine learning that uses neural networks to learn from large amounts of data.")
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 350)
      }
      
      Text("Don't worry if you don't understand all of these terms yet! Throughout this course, we'll explore these concepts in more detail and see how they apply to real-world applications.")
        .font(.body)
    }
  }
}

struct WhatIsAILesson2: View {
  let session: LanguageModelSession
  
  @State private var llmOutput: String = ""
  
  init(session: LanguageModelSession = LanguageModelSession(instructions: "You are a professional kids author, who specialises in writing short 130-150 word stories for children. Don't say anything like 'here is the story', just give it to me")) {
    self.session = session
  }
  
  var body: some View {
    VStack {
      Text("Artificial Intelligence is the simple idea of getting computers to act in a way that feel intelligent")
        .font(.largeTitle)
        .bold()
      
      Text("But how do we get computers to do this?")
        .font(.title2)
      
      Text("One way is through Language Models, which are trained on vast amounts of text data to understand and generate human-like language. Let's see an example of a Language Model in action!")
        .font(.body)
      
      if !llmOutput.isEmpty {
        ScrollView {
          Text(llmOutput)
        }
        .frame(maxWidth: 600, maxHeight: 200)
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .intelligence(shape: .rect(cornerRadius: 15))
      }
    }
    .onAppear {
      session.prewarm()
      Task {
        await generateOutput()
      }
    }
  }
  
  func generateOutput() async {
    do {
      let stream = session.streamResponse(to: "Tell me a super short story about a magical cat. Make it a maximum of 150 words.")
      for try await chunk in stream {
        withAnimation(.bouncy) {
          llmOutput = chunk.content
        }
      }
    } catch {
      print("Error generating output: \(error)")
      #if DEBUG
      llmOutput = "Error generating output: \(error)"
      #endif
    }
  }
}

struct WhatIsAILesson3: View {
  @State private var digits: [Int]
  @State private var showCheckmark: Bool = false
  @State private var currentImageName: String = "cat"
  @State private var detectionMessage: String = "Detecting..."
  @State private var isCatDetected: Bool = false
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  init() {
    _digits = State(initialValue: (0..<8).map { _ in Int.random(in: 0...1) })
  }
  
  var body: some View {
    VStack {
      Text("Machine Learning is a way we can teach computers to learn from data, rather than programming them with specific instructions.")
        .font(.largeTitle)
        .bold()
        .padding()
      
      Text("They're essentially just finding patterns in data. Let's see an example of a simple machine learning model that can detect whether an image contains a cat or not.")
        .font(.body)
        .padding()
      
      HStack {
        if let ext = currentImageName == "cat" ? "png" : "jpeg",
           let url = Bundle.main.url(forResource: currentImageName, withExtension: ext),
           let uiImage = UIImage(contentsOfFile: url.path) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 15))
            .frame(height: 200)
            .padding()
        }
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .padding()
        
        HStack {
          ForEach(digits.indices, id: \.self) { index in
            Text(String(digits[index]))
              .contentTransition(.numericText(value: Double(digits[index])))
              .font(.system(size: 48, weight: .bold, design: .monospaced))
              .foregroundStyle(showCheckmark ? (isCatDetected ? .green : .red) : .blue)
          }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
         
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .padding()
        
        VStack {
          // TODO: fix symbolEffect animation
          Image(systemName: isCatDetected ? "checkmark" : "xmark")
            .font(.largeTitle)
            .foregroundStyle(isCatDetected ? Color.green.gradient : Color.red.gradient)
            .symbolEffect(.drawOn, isActive: !showCheckmark)
          
          Text(detectionMessage)
            .font(.headline)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
      }
      .onReceive(timer) { _ in
        if !showCheckmark {
          withAnimation(.bouncy(duration: 0.1)) {
            digits = (0..<8).map { _ in Int.random(in: 0...1) }
          }
        }
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        withAnimation(.bouncy) {
          showCheckmark = true
          isCatDetected = true
          detectionMessage = "Cat Detected!"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          restartBinaryAnimation()
        }
      }
    }
  }
  
  func restartBinaryAnimation() {
    withAnimation(.bouncy) {
      currentImageName = "C98E9FA1-B6CB-4589-87D2-E667AE92C9CD"
      
      showCheckmark = false
      detectionMessage = "Detecting..."
      isCatDetected = false
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      withAnimation(.bouncy) {
        showCheckmark = true
        detectionMessage = "No Cat Detected"
      }
    }
  }
}

struct WhatIsAILesson4: View {
  var body: some View {
    VStack {
      HStack {
        Circle()
        
        Image(systemName: "arrow.left.arrow.right")

        Circle()
      }
      
      HStack {
        Circle()
      }
      
      HStack {
        Circle()
        
        Image(systemName: "arrow.left.arrow.right")
        
        Circle()
      }
    }
  }
}
