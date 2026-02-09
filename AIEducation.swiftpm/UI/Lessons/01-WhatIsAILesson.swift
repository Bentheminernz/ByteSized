//
//  WhatIsAILesson.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import AVKit
import FoundationModels
import MediaPlayer
import SwiftUI

// MARK: - Status: Completed

struct WhatIsAILesson1: View {
  var body: some View {
    VStack {
      Text("What is AI?")
        .font(.largeTitle)
        .bold()

      Text(
        "When people think of AI (Artificial Intelligence), they often imagine chatbots, virtual assistants, or even robots. But AI is much more than that! And it comes in many different forms."
      )
      .font(.body)

      HStack {
        VStack {
          Image(systemName: "brain")
            .resizable()
            .scaledToFit()
            .frame(height: 100)

          Text("Artificial Intelligence")
            .font(.headline)

          Text(
            "AI is the broad concept of making computers do things that seem intelligent."
          )
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

          Text(
            "A subset of AI that focuses on teaching computers to learn from data."
          )
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

          Text(
            "A subset of machine learning that uses neural networks to learn from large amounts of data."
          )
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .frame(width: 350)
      }

      Text(
        "Don't worry if you don't understand all of these terms yet! Throughout this course, we'll explore these concepts in more detail and see how they apply to real-world applications."
      )
      .font(.body)
    }
  }
}

struct WhatIsAILesson2: View {
  @Environment(FoundationModelsService.self) var foundationModelsService

  @State private var llmOutput: String = ""

  // Using a variable where possible to eliminate spelling mistakes
  /// The session to use for this lesson
  let session: FoundationModelSession = .custom("WhatIsAILesson2")

  init(
    session: LanguageModelSession = LanguageModelSession(
      instructions:
        "You are a professional kids author, who specialises in writing short 130-150 word stories for children. Don't say anything like 'here is the story', just give it to me"
    )
  ) {
  }

  var body: some View {
    VStack {
      VStack(spacing: 8) {
        Text(
          "Artificial Intelligence is the simple idea of getting computers to act in a way that feel intelligent"
        )
        .font(.largeTitle)
        .bold()

        Text("But how do we get computers to do this?")
          .font(.title2)

        Text(
          "One way is through Language Models, which are trained on vast amounts of text data to understand and generate human-like language. Let's see an example of a Language Model in action!"
        )
        .font(.body)
      }

      Text(
        "Here we're prompting a Language Model to write a short story for children about a magical cat:"
      )
      .font(.headline)
      .padding(.top)

      if !llmOutput.isEmpty {
        ScrollView {
          Text(llmOutput)
        }
        .frame(maxWidth: 600, maxHeight: 200)
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
        .intelligence(in: .rect(cornerRadius: 15))
      }
    }
    .onAppear {
      Task {
        await generateOutput()
      }
    }
    .onDisappear {
      foundationModelsService.clearSession(for: session)
    }
  }

  func generateOutput() async {
    do {
      let stream = foundationModelsService.streamResponse(
        from: session,
      ) {
        "Tell me a super short story about a magical cat. Make it a maximum of 150 words."
      }

      for try await chunk in stream {
        withAnimation(.bouncy) {
          llmOutput = chunk.content
        }
      }
      foundationModelsService.completeStream(for: session)
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
      Text(
        "Machine Learning teaches computers to recognize patterns, just like how you learned what a cat looks like."
      )
      .font(.largeTitle)
      .bold()
      .padding()

      Text(
        "Behind the scenes, it's basically a giant math equation. The computer looks at thousands of cat pictures and keeps tweaking the numbers in its equation—trying over and over until it gets really accurate at spotting cats. It's like practicing until you get perfect!"
      )
      .font(.body)
      .padding()

      HStack {
        if let ext = currentImageName == "cat" ? "png" : "jpeg",
          let url = Bundle.main.url(
            forResource: currentImageName,
            withExtension: ext
          ),
          let uiImage = UIImage(contentsOfFile: url.path)
        {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 15))
            .frame(height: 200)
            .padding()
            .accessibilityLabel(currentImageName == "cat" ? "A photo of a cat" : "A photo of two palm trees on a sunny beach")
        }

        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .padding()

        HStack {
          ForEach(digits.indices, id: \.self) { index in
            Text(String(digits[index]))
              .contentTransition(.numericText(value: Double(digits[index])))
              .font(.system(size: 48, weight: .bold, design: .monospaced))
              .foregroundStyle(
                showCheckmark ? (isCatDetected ? .green : .red) : .blue
              )
          }
        }
        .accessibilityLabel("Random binary digits representing the machine learning model's internal state")
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))

        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .padding()

        VStack {
          Image(systemName: isCatDetected ? "checkmark" : "xmark")
            .font(.largeTitle)
            .foregroundStyle(
              isCatDetected ? Color.green.gradient : Color.red.gradient
            )
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
  @State private var player = AVPlayer(
    url: Bundle.main.url(forResource: "driving", withExtension: "mp4")!
  )
  @State private var vehicleState: VehicleState = .go

  enum VehicleState {
    case stop
    case braking
    case go

    var systemImageName: String {
      switch self {
      case .stop:
        return "car.fill"
      case .braking:
        return "car.fill"
      case .go:
        return "car.fill"
      }
    }

    var description: String {
      switch self {
      case .stop:
        return "Stop"
      case .braking:
        return "Brake"
      case .go:
        return "Go"
      }
    }

  }

  var body: some View {
    VStack {
      DefinableText(
        "Deep Learning is a special type of machine learning that uses structures called neural networks to learn from large amounts of data."
      )
      .font(.largeTitle.bold())
      .padding()

      Text(
        "An example of deep learning in action is self-driving cars. These cars use deep learning models to analyze video footage from cameras and make decisions about when to stop, brake, or go."
      )
      .font(.body)
      .padding()

      HStack {
        CleanVideoPlayer(player: player)
          .frame(width: 300, height: 200)
          .onAppear { player.play() }
          .onVideoTime(3, player) {
            vehicleState = .braking
          }
          .onVideoTime(17.0, player) {
            vehicleState = .stop
          }
          .onVideoTime(25.0, player) {
            vehicleState = .go
          }
          .accessibilityLabel("Video showing the view from a self-driving car as it approaches an intersection, stops at a red light, and then proceeds when the light turns green")

        Image(systemName: "arrow.right")
          .font(.largeTitle)

        NeuralNetwork()
          .frame(width: 400, height: 200)
          .accessibilityLabel("A simplified visualization of a neural network, showing how input data is processed through multiple connected layers to produce an output")

        Image(systemName: "arrow.right")
          .font(.largeTitle)

        VStack {
          Image(systemName: vehicleState.systemImageName)
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .foregroundStyle(
              vehicleState == .go ? Color.green.gradient : Color.red.gradient
            )
            .symbolEffect(.pulse, isActive: vehicleState == .go)

          Text(vehicleState.description)
            .font(.headline)
        }
        .frame(width: 120)
      }
    }
    .onAppear {
      player.seek(to: .zero)
      vehicleState = .stop
    }
  }
}

struct NeuralNetwork: View {
  var body: some View {
    GeometryReader { geo in
      let shortest = min(geo.size.width, geo.size.height)
      let circleSize = shortest * 0.27

      let w = geo.size.width
      let h = geo.size.height

      let topY = h * 0.20
      let midY = h * 0.50
      let botY = h * 0.80

      let leftX = w * 0.25
      let rightX = w * 0.75

      ZStack {
        circle(at: CGPoint(x: leftX, y: topY), size: circleSize)
        circle(at: CGPoint(x: rightX, y: topY), size: circleSize)
        circle(at: CGPoint(x: w / 2, y: midY), size: circleSize * 0.9)
        circle(at: CGPoint(x: leftX, y: botY), size: circleSize)
        circle(at: CGPoint(x: rightX, y: botY), size: circleSize)

        arrow(
          from: CGPoint(x: leftX, y: topY),
          to: CGPoint(x: rightX, y: topY)
        )

        arrow(
          from: CGPoint(x: leftX, y: botY),
          to: CGPoint(x: rightX, y: botY)
        )

        arrow(
          from: CGPoint(x: leftX, y: topY),
          to: CGPoint(x: w / 2, y: midY)
        )

        arrow(
          from: CGPoint(x: rightX, y: topY),
          to: CGPoint(x: w / 2, y: midY)
        )

        arrow(
          from: CGPoint(x: w / 2, y: midY),
          to: CGPoint(x: leftX, y: botY)
        )

        arrow(
          from: CGPoint(x: w / 2, y: midY),
          to: CGPoint(x: rightX, y: botY)
        )
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  func circle(at point: CGPoint, size: CGFloat) -> some View {
    Circle()
      .fill(Color.blue.gradient)
      .frame(width: size, height: size)
      .position(point)
  }

  func arrow(from: CGPoint, to: CGPoint) -> some View {
    let dx = to.x - from.x
    let dy = to.y - from.y
    let angle = atan2(dy, dx) * 180 / .pi

    return Image(systemName: "arrow.left.arrow.right")
      .font(.system(size: 36))
      .symbolEffect(.pulse)
      .symbolEffect(
        .wiggle.byLayer,
        options: .repeat(.continuous).speed(0.15)
      )
      .symbolRenderingMode(.palette)
      .foregroundStyle(Color.green.gradient, Color.blue.gradient)
      .rotationEffect(.degrees(angle))
      .position(
        CGPoint(
          x: (from.x + to.x) / 2,
          y: (from.y + to.y) / 2
        )
      )
  }
}
