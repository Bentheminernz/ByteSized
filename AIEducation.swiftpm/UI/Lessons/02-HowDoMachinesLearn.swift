//
//  02-HowDoMachinesLearn.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: Completed
import SwiftUI

struct Book: Identifiable {
  let id: UUID = UUID()
  let title: String
  let author: String
  let icon: String
  let color: Color
  
  static let books: [Book] = [
    Book(title: "To Kill a Mockingbird", author: "Harper Lee", icon: "bird", color: .blue),
    Book(title: "1984", author: "George Orwell", icon: "eye", color: .red),
    Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", icon: "star.fill", color: .yellow),
    Book(title: "Pride and Prejudice", author: "Jane Austen", icon: "heart.fill", color: .pink),
    Book(title: "The Catcher in the Rye", author: "J.D. Salinger", icon: "figure.walk", color: .orange),
    Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", icon: "crown.fill", color: .yellow),
    Book(title: "Animal Farm", author: "George Orwell", icon: "pawprint.fill", color: .brown),
    Book(title: "The Hobbit", author: "J.R.R. Tolkien", icon: "mountain.2.fill", color: .green),
    Book(title: "Fahrenheit 451", author: "Ray Bradbury", icon: "flame.fill", color: .orange),
    Book(title: "Brave New World", author: "Aldous Huxley", icon: "globe", color: .cyan),
    Book(title: "The Chronicles of Narnia", author: "C.S. Lewis", icon: "snow", color: .mint),
    Book(title: "Moby-Dick", author: "Herman Melville", icon: "water.waves", color: .blue),
    Book(title: "War and Peace", author: "Leo Tolstoy", icon: "flag.fill", color: .red),
    Book(title: "The Odyssey", author: "Homer", icon: "sailboat.fill", color: .teal),
    Book(title: "Frankenstein", author: "Mary Shelley", icon: "bolt.fill", color: .indigo),
    Book(title: "The Divine Comedy", author: "Dante Alighieri", icon: "sparkles", color: .yellow),
    Book(title: "Alice's Adventures in Wonderland", author: "Lewis Carroll", icon: "hare.fill", color: .purple),
    Book(title: "The Little Prince", author: "Antoine de Saint-Exupéry", icon: "moon.stars.fill", color: .yellow),
    Book(title: "Don Quixote", author: "Miguel de Cervantes", icon: "shield.fill", color: .brown),
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

// MARK: - Slide 2: Language Learning Process
struct HowDoMachinesLearn2: View {
  @State private var currentStep = 0
  @State private var typingText = ""
  @State private var isTyping = false
  
  let steps = [
    ("Reading Text", "AI reads millions of books, websites, and conversations"),
    ("Finding Patterns", "AI notices: 'Hello' → Name, 'Thank you' → You're welcome"),
    ("Understanding Context", "'Bank' = money place OR river side, depending on context"),
    ("Predicting Words", "AI predicts next word: 'The cat sat on the ___' → mat/chair"),
    ("Responding to You", "AI generates helpful responses word by word!")
  ]
  
  var body: some View {
    VStack(spacing: 20) {
      Text("How Does AI Learn Language?")
        .font(.title.bold())
      
      HStack(spacing: 8) {
        ForEach(0..<steps.count, id: \.self) { index in
          Circle()
            .fill(index <= currentStep ? Color.purple : Color.gray.opacity(0.3))
            .frame(width: 10, height: 10)
        }
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.purple.opacity(0.05))
          .frame(height: 400)
        
        VStack(spacing: 20) {
          Group {
            switch currentStep {
            case 0: ReadingVisual()
            case 1: PatternsVisual()
            case 2: ContextVisual()
            case 3: PredictionVisual()
            case 4: ResponseVisual(typingText: $typingText, isTyping: $isTyping)
            default: EmptyView()
            }
          }
          .frame(height: 200)
          
          Divider()
          
          VStack(spacing: 10) {
            Text(steps[currentStep].0)
              .font(.headline)
            Text(steps[currentStep].1)
              .font(.body)
              .foregroundStyle(.secondary)
              .multilineTextAlignment(.center)
          }
          .padding(.horizontal)
        }
        .padding()
      }
      
      HStack(spacing: 20) {
        Button {
          withAnimation {
            if currentStep > 0 {
              currentStep -= 1
              resetAnimations()
            }
          }
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("Previous")
          }
          .foregroundStyle(currentStep == 0 ? .gray : .purple)
          .padding()
          .frame(width: 150)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(currentStep == 0 ? Color.gray.opacity(0.1) : Color.purple.opacity(0.1))
          )
        }
        .buttonStyle(.plain)
        .disabled(currentStep == 0)
        
        Button {
          withAnimation {
            if currentStep < steps.count - 1 {
              currentStep += 1
              resetAnimations()
            }
          }
        } label: {
          HStack {
            Text("Next")
            Image(systemName: "chevron.right")
          }
          .foregroundStyle(currentStep == steps.count - 1 ? .gray : .purple)
          .padding()
          .frame(width: 150)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(currentStep == steps.count - 1 ? Color.gray.opacity(0.1) : Color.purple.opacity(0.1))
          )
        }
        .buttonStyle(.plain)
        .disabled(currentStep == steps.count - 1)
      }
    }
    .padding()
    .onChange(of: currentStep) { _, _ in
      if currentStep == 4 {
        startTypingAnimation()
      }
    }
  }
  
  func resetAnimations() {
    typingText = ""
    isTyping = false
  }
  
  func startTypingAnimation() {
    isTyping = true
    let fullText = "Sure! I'd be happy to help you with that."
    
    Task {
      for index in 0..<fullText.count {
        withAnimation(.bouncy) {
          typingText = String(fullText.prefix(index + 1))
        }
        try? await Task.sleep(for: .milliseconds(50))
      }
      isTyping = false
    }
  }
}

// MARK: - Components for Slide 2
struct ReadingVisual: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("AI's Training Library")
        .font(.subheadline.bold())
        .foregroundStyle(.purple)
      
      HStack(spacing: 15) {
        ForEach([("book.fill", "Books"), ("globe", "Websites"), ("bubble.left.and.bubble.right.fill", "Chats"), ("newspaper.fill", "News")], id: \.0) { icon, label in
          VStack(spacing: 6) {
            Image(systemName: icon)
              .font(.system(size: 35))
              .foregroundStyle(.purple)
            Text(label)
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
        }
      }
      
      Text("AI learns by reading billions of words from different sources")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }
}

struct PatternsVisual: View {
  var body: some View {
    VStack(spacing: 12) {
      Text("Common Language Patterns")
        .font(.subheadline.bold())
        .foregroundStyle(.purple)
      
      ForEach([("Hello", "Name"), ("Question?", "Answer!"), ("Thank you", "You're welcome")], id: \.0) { pattern in
        HStack(spacing: 12) {
          Text(pattern.0)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.purple.opacity(0.2)))
          
          Image(systemName: "arrow.right")
            .foregroundStyle(.purple)
          
          Text(pattern.1)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.2)))
        }
        .font(.body)
      }
      
      Text("AI learns what words typically follow others")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }
}

struct ContextVisual: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("Understanding Context")
        .font(.subheadline.bold())
        .foregroundStyle(.purple)
      
      Text("🏦 BANK")
        .font(.title2.bold())
        .foregroundStyle(.purple)
      
      HStack(spacing: 30) {
        VStack(spacing: 8) {
          Image(systemName: "building.columns.fill")
            .font(.system(size: 40))
            .foregroundStyle(.blue)
          Text("Money bank")
            .font(.caption)
          Text("\"I went to the bank\"")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .italic()
        }
        
        Text("vs")
          .font(.headline)
          .foregroundStyle(.secondary)
        
        VStack(spacing: 8) {
          Image(systemName: "water.waves")
            .font(.system(size: 40))
            .foregroundStyle(.cyan)
          Text("River bank")
            .font(.caption)
          Text("\"Sat by the river bank\"")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .italic()
        }
      }
      
      Text("AI uses surrounding words to understand meaning")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }
}

struct PredictionVisual: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("Next Word Prediction")
        .font(.subheadline.bold())
        .foregroundStyle(.purple)
      
      Text("The cat sat on the")
        .font(.title3)
      
      HStack(spacing: 12) {
        ForEach(["mat", "chair", "floor"], id: \.self) { word in
          VStack(spacing: 4) {
            Text(word)
              .font(.headline)
              .foregroundStyle(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(RoundedRectangle(cornerRadius: 8).fill(Color.purple))
            
            if word == "mat" {
              Text("Most likely")
                .font(.caption2)
                .foregroundStyle(.green)
            }
          }
        }
      }
      
      Text("AI calculates probability for each possible word")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
  }
}

struct ResponseVisual: View {
  @Binding var typingText: String
  @Binding var isTyping: Bool
  
  var body: some View {
    VStack(spacing: 15) {
      Text("Real-Time Response Generation")
        .font(.subheadline.bold())
        .foregroundStyle(.purple)
      
      HStack {
        Spacer()
        VStack(alignment: .trailing, spacing: 4) {
          Text("You")
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text("Can you help me?")
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue.opacity(0.2)))
        }
      }
      
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          HStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
              .foregroundStyle(.purple)
            Text("AI")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
          
          Text(typingText.isEmpty ? "..." : typingText)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.purple.opacity(0.1)))
          
          if isTyping {
            HStack(spacing: 4) {
              Text("Thinking")
                .font(.caption2)
                .foregroundStyle(.secondary)
              
              Image(systemName: "ellipsis")
                .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
            }
          }
        }
        Spacer()
      }
      
      Text("Each word is predicted based on all previous words")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding(.horizontal)
  }
}



// MARK: - Slide 3: Image Pattern Recognition
struct HowDoMachinesLearn3: View {
  @State private var currentStep = 0
  @State private var showPattern = false
  
  let steps = [
    LearningStep(
      title: "Step 1: AI Sees Raw Data",
      description: "When you show AI a picture, it doesn't \"see\" a cat like you do. It sees numbers - pixels with different colors and brightness.",
      visual: .pixelGrid
    ),
    LearningStep(
      title: "Step 2: AI Finds Patterns",
      description: "After seeing MANY cat pictures, AI starts noticing patterns: \"Cats usually have triangular shapes on top (ears), circular shapes in the middle (eyes), and thin lines (whiskers).\"",
      visual: .patterns
    ),
    LearningStep(
      title: "Step 3: AI Learns What Makes a Cat",
      description: "Eventually, AI learns: If I see triangular ears + round eyes + whiskers + small nose = probably a cat! These patterns help AI recognize cats it's never seen before.",
      visual: .recognition
    ),
    LearningStep(
      title: "The Key Insight",
      description: "AI doesn't memorize every cat picture. Instead, it learns the PATTERNS that make something a cat. That's why it can recognize new cats!",
      visual: .insight
    )
  ]
  
  struct LearningStep {
    let title: String
    let description: String
    let visual: VisualType
    
    enum VisualType {
      case pixelGrid
      case patterns
      case recognition
      case insight
    }
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Text("How Does AI Recognize Patterns?")
        .font(.title.bold())
      
      HStack(spacing: 10) {
        ForEach(0..<steps.count, id: \.self) { index in
          Circle()
            .fill(index <= currentStep ? Color.blue : Color.gray.opacity(0.3))
            .frame(width: 12, height: 12)
        }
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.blue.opacity(0.05))
          .frame(height: 450)
        
        VStack(spacing: 20) {
          Group {
            switch steps[currentStep].visual {
            case .pixelGrid:
              PixelGridView()
            case .patterns:
              PatternDetectionView(showPattern: $showPattern)
            case .recognition:
              RecognitionView()
            case .insight:
              InsightView()
            }
          }
          .frame(height: 250)
          
          Divider()
            .padding(.horizontal)
          
          VStack(spacing: 12) {
            Text(steps[currentStep].title)
              .font(.headline)
            
            Text(steps[currentStep].description)
              .font(.body)
              .foregroundStyle(.secondary)
              .multilineTextAlignment(.center)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(.horizontal)
        }
        .padding()
      }
      
      HStack(spacing: 20) {
        Button {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            if currentStep > 0 {
              currentStep -= 1
              showPattern = false
            }
          }
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("Previous")
          }
          .foregroundStyle(currentStep == 0 ? .gray : .blue)
          .padding()
          .frame(width: 150)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(currentStep == 0 ? Color.gray.opacity(0.1) : Color.blue.opacity(0.1))
          )
        }
        .buttonStyle(.plain)
        .disabled(currentStep == 0)
        
        Button {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            if currentStep < steps.count - 1 {
              currentStep += 1
              showPattern = false
            }
          }
        } label: {
          HStack {
            Text("Next")
            Image(systemName: "chevron.right")
          }
          .foregroundStyle(currentStep == steps.count - 1 ? .gray : .blue)
          .padding()
          .frame(width: 150)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(currentStep == steps.count - 1 ? Color.gray.opacity(0.1) : Color.blue.opacity(0.1))
          )
        }
        .buttonStyle(.plain)
        .disabled(currentStep == steps.count - 1)
      }
    }
    .padding()
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        showPattern = true
      }
    }
    .onChange(of: currentStep) { _, newValue in
      if newValue == 1 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          showPattern = true
        }
      }
    }
  }
}


struct PixelGridView: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("What AI Actually Sees:")
        .font(.caption.bold())
      
      VStack(spacing: 4) {
        /// Vertical Stack of 6 rows
        ForEach(0..<6, id: \.self) { row in
          HStack(spacing: 4) {
            /// Horizontal Stack of 8 columns
            ForEach(0..<8, id: \.self) { col in
              let value = Int.random(in: 0...255)
              /// Each pixel represented as a square with brightness
              Rectangle()
                .fill(Color(white: Double(value) / 255.0))
                .frame(width: 30, height: 30)
                .overlay(
                  Text("\(value)")
                    .font(.system(size: 8))
                    .foregroundStyle(value > 127 ? .black : .white)
                )
            }
          }
        }
      }
      
      Text("Just numbers representing brightness!")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  }
}

struct PatternDetectionView: View {
  @Binding var showPattern: Bool
  
  var body: some View {
    VStack(spacing: 15) {
      Text("After seeing MANY examples:")
        .font(.caption.bold())
      
      HStack(spacing: 30) {
        ForEach(0..<3, id: \.self) { index in
          SimpleCatFace(highlighted: showPattern, delay: Double(index) * 0.2)
            .frame(width: 80, height: 80)
        }
      }
      
      if showPattern {
        VStack(spacing: 8) {
          Image(systemName: "arrow.down")
            .foregroundStyle(.blue)
            .font(.title2)
            .transition(.scale.combined(with: .opacity))
          
          Text("AI notices: \"Triangles on top + circles in middle = Cat!\"")
            .font(.caption.bold())
            .foregroundStyle(.blue)
            .transition(.scale.combined(with: .opacity))
        }
      }
    }
  }
}

struct SimpleCatFace: View {
  let highlighted: Bool
  let delay: Double
  @State private var showHighlight = false
  
  var body: some View {
    ZStack {
      /// Ears
      HStack(spacing: 40) {
        Triangle()
          .fill(showHighlight ? .purple : .gray.opacity(0.3))
          .frame(width: 20, height: 25)
          .offset(y: -30)
        
        Triangle()
          .fill(showHighlight ? .purple : .gray.opacity(0.3))
          .frame(width: 20, height: 25)
          .offset(y: -30)
      }
      
      /// Eyes
      HStack(spacing: 20) {
        Circle()
          .fill(showHighlight ? .blue : .gray.opacity(0.4))
          .frame(width: 12, height: 12)
        
        Circle()
          .fill(showHighlight ? .blue : .gray.opacity(0.4))
          .frame(width: 12, height: 12)
      }
    }
    .onChange(of: highlighted) { _, newValue in
      if newValue {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            showHighlight = true
          }
        }
      } else {
        showHighlight = false
      }
    }
  }
}

struct RecognitionView: View {
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 30) {
        VStack {
          Text("New Image")
            .font(.caption.bold())
          
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .fill(.gray.opacity(0.1))
              .frame(width: 100, height: 100)
            
            VStack(spacing: 5) {
              HStack(spacing: 30) {
                Triangle().fill(.purple).frame(width: 15, height: 20)
                Triangle().fill(.purple).frame(width: 15, height: 20)
              }
              HStack(spacing: 15) {
                Circle().fill(.blue).frame(width: 10, height: 10)
                Circle().fill(.blue).frame(width: 10, height: 10)
              }
            }
          }
          
          Text("Never seen before!")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
        Image(systemName: "arrow.right.circle.fill")
          .font(.largeTitle)
          .foregroundStyle(.blue)
        
        VStack {
          Text("AI Thinks...")
            .font(.caption.bold())
          
          VStack(spacing: 10) {
            HStack {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("Triangles on top ✓")
                .font(.caption)
            }
            HStack {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
              Text("Circles in middle ✓")
                .font(.caption)
            }
            
            Divider()
            
            Text("This is a CAT! 🐱")
              .font(.headline)
              .foregroundStyle(.blue)
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(.blue.opacity(0.1))
          )
        }
      }
    }
  }
}

struct InsightView: View {
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 40) {
        VStack {
          Image(systemName: "xmark.circle.fill")
            .font(.system(size: 40))
            .foregroundStyle(.red)
          Text("Memorizing")
            .font(.headline)
          Text("\"This exact picture is a cat\"")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
          Text("❌ Won't work on new images")
            .font(.caption)
            .foregroundStyle(.red)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 15)
            .fill(.red.opacity(0.1))
        )
        
        VStack {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 40))
            .foregroundStyle(.green)
          Text("Learning Patterns")
            .font(.headline)
          Text("\"Triangular ears + round eyes = cat\"")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
          Text("✅ Works on ANY cat!")
            .font(.caption)
            .foregroundStyle(.green)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 15)
            .fill(.green.opacity(0.1))
        )
      }
      
      Text("That's why we need LOTS of examples - to find the real patterns!")
        .font(.caption.bold())
        .foregroundStyle(.blue)
    }
  }
}


// MARK: - Slide 3: Training vs Testing
struct HowDoMachinesLearn4: View {
  @State private var currentPhase: LearningPhase = .training
  @State private var trainingProgress: Double = 0
  @State private var testingProgress: Double = 0
  @State private var accuracy: Int = 0
  @State private var isAnimating = false
  
  enum LearningPhase {
    case training
    case testing
    case complete
    
    var title: String {
      switch self {
      case .training: return "Training Phase"
      case .testing: return "Testing Phase"
      case .complete: return "Learning Complete!"
      }
    }
    
    var description: String {
      switch self {
      case .training: return "AI practices on example data"
      case .testing: return "AI gets tested on NEW data it hasn't seen"
      case .complete: return "AI is now ready to make predictions!"
      }
    }
    
    var color: Color {
      switch self {
      case .training: return .blue
      case .testing: return .orange
      case .complete: return .green
      }
    }
    
    var icon: String {
      switch self {
      case .training: return "book.fill"
      case .testing: return "checkmark.circle.fill"
      case .complete: return "star.fill"
      }
    }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        Text("How AI Learns: Training vs Testing")
          .font(.title.bold())
        
        Text(
          "Just like studying for a test - AI practices on examples (training), then gets tested on NEW examples it hasn't seen before (testing)!"
        )
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        
        HStack(spacing: 20) {
          PhaseCard(
            phase: .training,
            isActive: currentPhase == .training,
            isComplete: currentPhase != .training
          )
          
          Image(systemName: "arrow.right")
            .font(.title)
            .foregroundStyle(currentPhase != .training ? .green : .gray)
          
          PhaseCard(
            phase: .testing,
            isActive: currentPhase == .testing,
            isComplete: currentPhase == .complete
          )
          
          Image(systemName: "arrow.right")
            .font(.title)
            .foregroundStyle(currentPhase == .complete ? .green : .gray)
          
          PhaseCard(
            phase: .complete,
            isActive: currentPhase == .complete,
            isComplete: currentPhase == .complete
          )
        }
        
        VStack(spacing: 20) {
          ZStack {
            RoundedRectangle(cornerRadius: 15)
              .fill(currentPhase.color.opacity(0.1))
              .frame(height: 300)
            
            VStack(spacing: 20) {
              Image(systemName: currentPhase.icon)
                .font(.system(size: 60))
                .foregroundStyle(currentPhase.color)
              
              Text(currentPhase.title)
                .font(.title2.bold())
              
              Text(currentPhase.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
              
              if currentPhase == .training {
                VStack(spacing: 10) {
                  ProgressView(value: trainingProgress, total: 1.0)
                    .tint(.blue)
                    .frame(width: 300)
                  
                  Text("Progress: \(Int(trainingProgress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
              } else if currentPhase == .testing {
                VStack(spacing: 10) {
                  ProgressView(value: min(max(testingProgress, 0), 1), total: 1.0)
                    .tint(.orange)
                    .frame(width: 300)
                  
                  HStack(spacing: 20) {
                    Text("Progress: \(Int(testingProgress * 100))%")
                    Text("Accuracy: \(accuracy)%")
                  }
                  .font(.caption)
                  .foregroundStyle(.secondary)
                }
              } else {
                VStack(spacing: 10) {
                  HStack {
                    Image(systemName: "checkmark.circle.fill")
                      .foregroundStyle(.green)
                    Text("Final Accuracy: \(accuracy)%")
                      .font(.headline)
                  }
                  
                  if accuracy >= 90 {
                    Text("Excellent! This AI is ready to use! 🎉")
                      .font(.caption)
                      .foregroundStyle(.green)
                  } else if accuracy >= 70 {
                    Text("Good! The AI learned well!")
                      .font(.caption)
                      .foregroundStyle(.orange)
                  } else {
                    Text("Needs more training data!")
                      .font(.caption)
                      .foregroundStyle(.red)
                  }
                }
              }
            }
            .padding()
          }
          
          Button {
            startLearningAnimation()
          } label: {
            HStack {
              Image(systemName: isAnimating ? "stop.circle.fill" : "play.circle.fill")
              Text(isAnimating ? "Reset" : "Start Learning Process")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 10)
                .fill(isAnimating ? .red : .blue)
            )
          }
          .buttonStyle(.plain)
          .disabled(isAnimating && currentPhase != .complete)
        }
      }
      .padding(.horizontal)
    }
  }
  
  func startLearningAnimation() {
    if isAnimating && currentPhase == .complete {
      currentPhase = .training
      trainingProgress = 0
      testingProgress = 0
      accuracy = 0
      isAnimating = false
      return
    }
    
    isAnimating = true
    currentPhase = .training
    
    /// training phase
    withAnimation(.linear(duration: 2.0)) {
      trainingProgress = 1.0
    }
    
    Task {
      try? await Task.sleep(for: .seconds(2.03))
      currentPhase = .testing
      ///   testing phase
      
      while testingProgress < 1.0 {
        try? await Task.sleep(for: .seconds(0.05))
        testingProgress += 0.025
        testingProgress = min(testingProgress, 1.0)
        accuracy = Int(testingProgress * Double.random(in: 85...95))
      }
      
      testingProgress = 1.0
      accuracy = Int.random(in: 88...96)
      
      try? await Task.sleep(for: .seconds(0.5))
      withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
        currentPhase = .complete
      }
    }
  }
}

struct PhaseCard: View {
  let phase: HowDoMachinesLearn4.LearningPhase
  let isActive: Bool
  let isComplete: Bool
  
  var body: some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(isComplete ? phase.color : (isActive ? phase.color.opacity(0.3) : Color.gray.opacity(0.2)))
          .frame(width: 60, height: 60)
        
        if isComplete {
          Image(systemName: "checkmark")
            .foregroundStyle(.white)
            .font(.title2.bold())
        } else {
          Image(systemName: phase.icon)
            .foregroundStyle(isActive ? phase.color : .gray)
            .font(.title3)
        }
      }
      
      Text(phase.title)
        .font(.caption.bold())
        .foregroundStyle(isActive || isComplete ? .primary : .secondary)
    }
    .frame(width: 120)
  }
}

// MARK: - Slide 4: More Data = Better Results
struct HowDoMachinesLearn5: View {
  @State private var selectedBrain: BrainSize = .small
  @State private var showComparison = false
  
  enum BrainSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var dataCount: String {
      switch self {
      case .small: return "10 examples"
      case .medium: return "100 examples"
      case .large: return "10,000+ examples"
      }
    }
    
    var accuracy: Int {
      switch self {
      case .small: return Int.random(in: 25...32)
      case .medium: return Int.random(in: 52...65)
      case .large: return Int.random(in: 85...97)
      }
    }
    
    var color: Color {
      switch self {
      case .small: return .red
      case .medium: return .orange
      case .large: return .green
      }
    }
    
    var size: CGFloat {
      switch self {
      case .small: return 80
      case .medium: return 120
      case .large: return 160
      }
    }
    
    var description: String {
      switch self {
      case .small: return "Like learning basketball after 5 practice shots - you'll miss a lot!"
      case .medium: return "Getting better! Like practicing for a few weeks."
      case .large: return "Expert level! Like practicing for years - very accurate!"
      }
    }
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        Text("The More Data, The Better!")
          .font(.title.bold())
        
        Text(
          "AI needs LOTS of examples to get really good. Think of it like sports - you wouldn't expect to be great at basketball after just 5 practice shots!"
        )
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        
        HStack(spacing: 20) {
          ForEach(BrainSize.allCases, id: \.self) { size in
            Button {
              withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedBrain = size
              }
            } label: {
              VStack(spacing: 10) {
                ZStack {
                  Circle()
                    .fill(size.color.opacity(selectedBrain == size ? 0.3 : 0.1))
                    .frame(width: 100, height: 100)
                  
                  Image(systemName: "brain.head.profile")
                    .font(.system(size: 40))
                    .foregroundStyle(size.color)
                }
                
                Text(size.rawValue)
                  .font(.headline)
                  .foregroundStyle(selectedBrain == size ? size.color : .secondary)
              }
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 15)
                  .fill(selectedBrain == size ? size.color.opacity(0.1) : Color.clear)
              )
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .stroke(selectedBrain == size ? size.color : Color.clear, lineWidth: 3)
              )
            }
            .buttonStyle(.plain)
          }
        }
        
        VStack(spacing: 20) {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .fill(selectedBrain.color.opacity(0.1))
              .frame(height: 350)
            
            VStack(spacing: 25) {
              ZStack {
                ForEach(0..<3) { index in
                  Circle()
                    .stroke(selectedBrain.color.opacity(0.3), lineWidth: 2)
                    .frame(width: selectedBrain.size + CGFloat(index * 20))
                    .opacity(showComparison ? 0.5 : 0)
                    .animation(
                      .easeInOut(duration: 1.5)
                      .repeatForever(autoreverses: true)
                      .delay(Double(index) * 0.3),
                      value: showComparison
                    )
                }
                
                Image(systemName: "brain.head.profile")
                  .font(.system(size: selectedBrain.size))
                  .foregroundStyle(selectedBrain.color)
              }
              .frame(height: 180)
              
              VStack(spacing: 15) {
                HStack {
                  Image(systemName: "chart.bar.fill", variableValue: Double(selectedBrain.accuracy) / 100)
                    .foregroundStyle(selectedBrain.color)
                    .symbolVariableValueMode(.color)
                  
                  Text("Training Data:")
                    .foregroundStyle(.secondary)
                  Text(selectedBrain.dataCount)
                    .contentTransition(.numericText(value: Double(selectedBrain.accuracy)))
                    .bold()
                }
                
                VStack(spacing: 8) {
                  HStack {
                    Text("Accuracy:")
                      .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(selectedBrain.accuracy)%")
                      .contentTransition(.numericText(value: Double(selectedBrain.accuracy)))
                      .bold()
                      .foregroundStyle(selectedBrain.color)
                  }
                  
                  GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                      RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 20)
                      
                      RoundedRectangle(cornerRadius: 10)
                        .fill(selectedBrain.color)
                        .frame(
                          width: geometry.size.width * (CGFloat(selectedBrain.accuracy) / 100),
                          height: 20
                        )
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: selectedBrain)
                    }
                  }
                  .frame(height: 20)
                }
                
                Text(selectedBrain.description)
                  .font(.body)
                  .foregroundStyle(.secondary)
                  .multilineTextAlignment(.center)
                  .italic()
              }
              .padding(.horizontal)
            }
          }
        }
        
        Text("Click on different brain sizes to see how more data improves accuracy!")
          .font(.caption)
          .foregroundStyle(.secondary)
          .italic()
      }
      .padding(.horizontal)
      .onAppear {
        showComparison = true
      }
    }
  }
}

