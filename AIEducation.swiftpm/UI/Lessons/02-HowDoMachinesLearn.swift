//
//  02-HowDoMachinesLearn.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: WIP
import SwiftUI

struct Book: Identifiable {
  let id: UUID = UUID()
  let title: String
  let author: String
  let icon: String
  let color: Color

  static let books: [Book] = [
    Book(
      title: "To Kill a Mockingbird",
      author: "Harper Lee",
      icon: "bird",
      color: .blue
    ),
    Book(title: "1984", author: "George Orwell", icon: "eye", color: .red),
    Book(
      title: "The Great Gatsby",
      author: "F. Scott Fitzgerald",
      icon: "star.fill",
      color: .yellow
    ),
    Book(
      title: "Pride and Prejudice",
      author: "Jane Austen",
      icon: "heart.fill",
      color: .pink
    ),
    Book(
      title: "The Catcher in the Rye",
      author: "J.D. Salinger",
      icon: "figure.walk",
      color: .orange
    ),
    Book(
      title: "The Lord of the Rings",
      author: "J.R.R. Tolkien",
      icon: "crown.fill",
      color: .yellow
    ),
    Book(
      title: "Animal Farm",
      author: "George Orwell",
      icon: "pawprint.fill",
      color: .brown
    ),
    Book(
      title: "The Hobbit",
      author: "J.R.R. Tolkien",
      icon: "mountain.2.fill",
      color: .green
    ),
    Book(
      title: "Fahrenheit 451",
      author: "Ray Bradbury",
      icon: "flame.fill",
      color: .orange
    ),
    Book(
      title: "Brave New World",
      author: "Aldous Huxley",
      icon: "globe",
      color: .cyan
    ),
    Book(
      title: "The Chronicles of Narnia",
      author: "C.S. Lewis",
      icon: "snow",
      color: .mint
    ),
    Book(
      title: "Moby-Dick",
      author: "Herman Melville",
      icon: "water.waves",
      color: .blue
    ),
    Book(
      title: "War and Peace",
      author: "Leo Tolstoy",
      icon: "flag.fill",
      color: .red
    ),
    Book(
      title: "The Odyssey",
      author: "Homer",
      icon: "sailboat.fill",
      color: .teal
    ),
    Book(
      title: "Frankenstein",
      author: "Mary Shelley",
      icon: "bolt.fill",
      color: .indigo
    ),
    Book(
      title: "The Divine Comedy",
      author: "Dante Alighieri",
      icon: "sparkles",
      color: .yellow
    ),
    Book(
      title: "Alice's Adventures in Wonderland",
      author: "Lewis Carroll",
      icon: "hare.fill",
      color: .purple
    ),
    Book(
      title: "The Little Prince",
      author: "Antoine de Saint-Exupéry",
      icon: "moon.stars.fill",
      color: .yellow
    ),
    Book(
      title: "Don Quixote",
      author: "Miguel de Cervantes",
      icon: "shield.fill",
      color: .brown
    ),
  ]
}

struct BookView: View {
  let book: Book

  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(book.color.gradient)
        .frame(width: 150, height: 225)
        .overlay(
          VStack {
            Image(systemName: book.icon)
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
              .foregroundStyle(.white)

            Spacer()

            Text(book.title)
              .font(.headline)
              .fontDesign(.rounded)
              .foregroundStyle(.white)
            Text(book.author)
              .font(.subheadline)
              .fontDesign(.rounded)
              .foregroundStyle(.white)

            Spacer()
          }
          .padding(.vertical)
        )
    }
  }
}

struct HowDoMachinesLearn1: View {
  @State private var imageCache: [String: UIImage] = [:]

  private var mixedContent: [FallingContent] {
    let books = Book.books.map { FallingContent.book($0) }
    let images = FallingImage.natureImageFilenames.map {
      FallingContent.image($0)
    }
    return books + images
  }

  enum FallingContent: Identifiable {
    case book(Book)
    case image(String)

    var id: String {
      switch self {
      case .book(let book):
        return "book-\(book.id)"
      case .image(let filename):
        return "image-\(filename)"
      }
    }
  }

  var body: some View {
    VStack {
      FallingItemsView(
        items: mixedContent,
        itemsToShow: 8,
        spawnInterval: 0.5,
        durationRange: 6...10
      ) { content in
        switch content {
        case .book(let book):
          BookView(book: book)

        case .image(let filename):
          if let uiImage = imageCache[filename] {
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
      }
      .overlay(
        VStack(spacing: 20) {
          Text("Machines Learn by Example")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.primary)

          Text(
            "Just like humans, machines learn by being exposed to many examples. The more diverse and comprehensive the examples, the better the learning."
          )
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 15))
      )
    }
    .onAppear {
      preloadImages()
    }
  }

  func preloadImages() {
    DispatchQueue.global(qos: .userInitiated).async {
      let loadedImages = FallingImage.natureImageFilenames.compactMap {
        filename -> (String, UIImage)? in
        guard let path = Bundle.main.path(forResource: filename, ofType: nil),
          let image = UIImage(contentsOfFile: path)
        else {
          return nil
        }
        let size = CGSize(width: 80, height: 80)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let resizedImage = renderer.image { context in
          image.draw(in: CGRect(origin: .zero, size: size))
        }
        return (filename, resizedImage)
      }

      DispatchQueue.main.async {
        self.imageCache = Dictionary(uniqueKeysWithValues: loadedImages)
      }
    }
  }
}

struct HowDoMachinesLearnPage2: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 12) {
        LearningOverviewView()
        TrainingVisualizerView()
      }
      .padding()
    }
  }
}

struct LearningOverviewView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      DefinableText(
        "Machines learn by reducing loss across epochs using a model that fits patterns in data.\nIn this demo, the model is a simple function y = ax^2 + bx + c trained on noisy examples."
      )
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(.secondarySystemBackground))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(.secondary.opacity(0.2), lineWidth: 1)
      )
    }
  }
}

struct TrainingVisualizerView: View {
  @State private var points: [CGPoint] = []
  @State private var epochs: Int = 0
  @State private var running: Bool = true
  @State private var noise: CGFloat = 0.25
  @State private var speed: Double = 1.0
  @State private var lossHistory: [Double] = []
  @State private var modelParams = ModelParams(a: 0.0, b: 0.0, c: 0.0)

  private let maxEpochs = 300
  private let timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common)
    .autoconnect()

  var body: some View {
    VStack(spacing: 16) {
      GeometryReader { geo in
        ZStack {
          ScatterView(points: normalized(points), in: geo.size)
            .opacity(0.9)

          CurveView(params: modelParams, in: geo.size)
            .stroke(Color.blue, lineWidth: 2)
            .shadow(color: .blue.opacity(0.2), radius: 4, x: 0, y: 0)

          GridBackground().stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        }
      }
      .frame(height: 260)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.15))
      )

      VStack(spacing: 8) {
        HStack {
          Text("Epoch: \(epochs)")
          Spacer()
          Text(String(format: "Loss: %.3f", lossHistory.last ?? 0.0))
        }
        LossSparkline(lossHistory: lossHistory)
          .frame(height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.2))
          )

        ProgressView(value: min(Double(epochs) / Double(maxEpochs), 1.0))
          .tint(.blue)
      }

      VStack(spacing: 8) {
        HStack {
          Label("Noise", systemImage: "waveform.path")
          Slider(value: $noise, in: 0.0...0.6) { _ in
            regenerateData(resetModel: true)
          }
          .animation(.bouncy, value: noise)
        }
        HStack {
          Label("Speed", systemImage: "speedometer")
          Slider(value: $speed, in: 0.3...2.0)
        }
        HStack {
          Button(running ? "Pause" : "Resume") { running.toggle() }
          Button("Reset") { resetAll() }
          Spacer()
          Button("Regenerate Data") { regenerateData(resetModel: true) }
        }
      }

      DefinableText(
        "The view shows noisy data points (examples), the model’s current prediction curve, and a loss chart. Over epochs, parameters a, b, and c update to lower loss."
      )
    }
    .onAppear { setup() }
    .onReceive(timer) { _ in tick() }
  }

  // MARK: - Training loop
  private func setup() {
    regenerateData(resetModel: true)
    epochs = 0
    lossHistory = []
  }

  private func resetAll() {
    running = false
    setup()
    running = true
  }

  private func regenerateData(resetModel: Bool) {
    points = makeSyntheticData(count: 40, noise: noise)
    lossHistory.removeAll()
    epochs = 0
    if resetModel {
      modelParams = .init(a: 0.0, b: 0.0, c: 0.0)
    }
  }

  private func tick() {
    guard running, epochs < maxEpochs else { return }
    let target = ModelParams(a: 0.8, b: -0.2, c: 0.1)
    let lr = 0.02 * speed
    let grads = gradient(params: modelParams, target: target)
    modelParams.a += grads.a * lr
    modelParams.b += grads.b * lr
    modelParams.c += grads.c * lr

    let loss = mse(params: modelParams, data: points)
    lossHistory.append(loss)
    epochs += 1
  }

  // MARK: - Data + math
  private func makeSyntheticData(count: Int, noise: CGFloat) -> [CGPoint] {
    let target = ModelParams(a: 0.8, b: -0.2, c: 0.1)
    let xs = (0..<count).map { CGFloat($0) / CGFloat(max(count - 1, 1)) }
    return xs.map { x in
      let yTrue = target.a * x * x + target.b * x + target.c
      let n = (CGFloat.random(in: -1...1)) * noise
      return CGPoint(x: x, y: clamp(yTrue + n, 0, 1))
    }
  }

  private func mse(params: ModelParams, data: [CGPoint]) -> Double {
    guard !data.isEmpty else { return 0 }
    let err = data.map { p -> Double in
      let yHat = params.a * p.x * p.x + params.b * p.x + params.c
      let d = Double(yHat - p.y)
      return d * d
    }
    return err.reduce(0, +) / Double(data.count)
  }

  private func gradient(params: ModelParams, target: ModelParams) -> ModelParams
  {
    ModelParams(
      a: target.a - params.a,
      b: target.b - params.b,
      c: target.c - params.c
    )
  }

  private func normalized(_ pts: [CGPoint]) -> [CGPoint] { pts }
  private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
    min(max(v, lo), hi)
  }
}

// MARK: - Drawing helpers

struct ModelParams {
  var a: CGFloat
  var b: CGFloat
  var c: CGFloat
}

struct ScatterView: View {
  let points: [CGPoint]
  let size: CGSize

  init(points: [CGPoint], in size: CGSize) {
    self.points = points
    self.size = size
  }

  var body: some View {
    Canvas { ctx, _ in
      for p in points {
        let pt = CGPoint(x: p.x * size.width, y: (1 - p.y) * size.height)
        let r = CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6)
        ctx.fill(Path(ellipseIn: r), with: .color(.purple.opacity(0.8)))
      }
    }
  }
}

struct CurveView: Shape {
  let params: ModelParams
  let size: CGSize

  init(params: ModelParams, in size: CGSize) {
    self.params = params
    self.size = size
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let steps = 200
    for i in 0...steps {
      let x = CGFloat(i) / CGFloat(steps)
      let y = params.a * x * x + params.b * x + params.c
      let px = x * rect.width
      let py = (1 - y) * rect.height
      if i == 0 {
        path.move(to: CGPoint(x: px, y: py))
      } else {
        path.addLine(to: CGPoint(x: px, y: py))
      }
    }
    return path
  }
}

struct GridBackground: Shape {
  func path(in rect: CGRect) -> Path {
    var p = Path()
    let step: CGFloat = max(20, rect.width / 12)
    for x in stride(from: 0, through: rect.width, by: step) {
      p.move(to: CGPoint(x: x, y: 0))
      p.addLine(to: CGPoint(x: x, y: rect.height))
    }
    for y in stride(from: 0, through: rect.height, by: step) {
      p.move(to: CGPoint(x: 0, y: y))
      p.addLine(to: CGPoint(x: rect.width, y: y))
    }
    return p
  }
}

struct LossSparkline: View {
  let lossHistory: [Double]

  var body: some View {
    GeometryReader { geo in
      Canvas { ctx, rect in
        guard lossHistory.count > 1 else { return }
        let maxL = max(lossHistory.max() ?? 1, 0.001)
        var path = Path()
        for i in lossHistory.indices {
          let x =
            CGFloat(i) / CGFloat(max(lossHistory.count - 1, 1)) * rect.width
          let y = CGFloat(1.0 - (lossHistory[i] / maxL)) * rect.height
          if i == lossHistory.startIndex {
            path.move(to: CGPoint(x: x, y: y))
          } else {
            path.addLine(to: CGPoint(x: x, y: y))
          }
        }
        ctx.stroke(path, with: .color(.pink), lineWidth: 2)
        var fill = path
        fill.addLine(to: CGPoint(x: rect.width, y: rect.height))
        fill.addLine(to: CGPoint(x: 0, y: rect.height))
        fill.closeSubpath()
        ctx.fill(fill, with: .color(.pink.opacity(0.15)))
      }
    }
  }
}
