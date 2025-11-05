//
//  ImageView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 05/11/2025.
//

import SwiftUI
import FoundationModels
import ImagePlayground

struct FallingImage: Identifiable {
    let id = UUID()
    let filename: String
    let xPosition: CGFloat
    let delay: Double
    let duration: Double
    let cachedImage: UIImage?
}

struct CascadingImagesView: View {
  let natureImageFilenames: [String] = [
    "3D3F56CC-E856-42F6-A5B3-C50C638DB5AF.jpeg",
    "3EC1B106-EEF1-4A1B-8C6F-AEE9CD93B36D.jpeg",
    "4ECC047F-9F80-4A31-A933-857A2C17ADCA.jpeg",
    "6BEB4786-62F3-4661-97C0-B7A20829A5E5.jpeg",
    "8EB0C9D7-2A65-4FB7-A016-D7F0D72A3993.jpeg",
    "15AB73A3-64FD-40D1-8208-E249D7D522B1.jpeg",
    "80AEA608-F20E-4415-9E91-3D97817DAA3B.jpeg",
    "84AB3CA0-AB9C-4203-9853-A830F4A7F59C.jpeg",
    "3984F2A0-4EBA-4924-BDEA-65FDE9690CFA.jpeg",
    "4562AD23-3AAE-4CAF-A8A5-8A5DE52F2B4A.jpeg",
    "29321CD2-162F-42CD-AA83-19F50EA7171B.jpeg",
    "A8525253-F45A-41DB-AD26-B28FC431E62A.jpeg",
    "BCF349A7-8797-4B47-AD7B-8AC8B269E2F9.jpeg",
    "C98E9FA1-B6CB-4589-87D2-E667AE92C9CD.jpeg",
    "CCCA9C54-8F85-4A95-ADED-B1A320F1BECA.jpeg",
    "E996E309-7CA6-4D04-8963-A11AF02EBD8D.jpeg",
    "E7533C1F-2A1E-4270-9023-E74C0C4D18D8.jpeg",
    "E556841E-0E3E-40A6-AF62-ABD6DFE36859.jpeg",
    "ED59E484-1801-418F-83AB-B18A725EDDBD.jpeg",
    "F9C5FC3D-D113-491D-97F6-180FE534894D.jpeg",
    "F1394BA7-8566-4E5D-A86F-F0C4EB49697F.jpeg"
  ]
  
  @State private var fallingImages: [FallingImage] = []
  @State private var screenHeight: CGFloat = 0
  @State private var imageCache: [String: UIImage] = [:]
  @State private var timer: Timer?
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.black.opacity(0.1)
          .ignoresSafeArea()
        
        ForEach(fallingImages) { fallingImage in
          FallingImageView(
            cachedImage: fallingImage.cachedImage,
            xPosition: fallingImage.xPosition,
            duration: fallingImage.duration,
            screenHeight: geometry.size.height,
            onComplete: {
              recycleImage(fallingImage)
            }
          )
        }
      }
      .onAppear {
        screenHeight = geometry.size.height
        preloadImages()
        
      }
      .onDisappear {
        timer?.invalidate()
        timer = nil
      }
    }
    .drawingGroup()
  }
  
  func preloadImages() {
    DispatchQueue.global(qos: .userInitiated).async {
      let loadedImages = natureImageFilenames.compactMap { filename -> (String, UIImage)? in
        guard let path = Bundle.main.path(forResource: filename, ofType: nil),
              let image = UIImage(contentsOfFile: path) else {
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
        self.generateInitialImages()
        self.startContinuousFlow()
      }
    }
  }
  
  func generateInitialImages() {
    for i in 0..<12 {
      addNewImage(delay: Double(i) * 0.4)
    }
  }
  
  func startContinuousFlow() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [weak timer] _ in
      addNewImage(delay: 0)
    }
  }
  
  func addNewImage(delay: Double) {
    let randomFilename = natureImageFilenames.randomElement() ?? natureImageFilenames[0]
    let xPosition = CGFloat.random(in: 0.1...0.9)
    let duration = Double.random(in: 6...10)
    
    let newImage = FallingImage(
      filename: randomFilename,
      xPosition: xPosition,
      delay: delay,
      duration: duration,
      cachedImage: imageCache[randomFilename]
    )
    
    fallingImages.append(newImage)
  }
  
  func recycleImage(_ image: FallingImage) {
    if let index = fallingImages.firstIndex(where: { $0.id == image.id }) {
      fallingImages.remove(at: index)
    }
  }
}

struct FallingImageView: View {
  let cachedImage: UIImage?
  let xPosition: CGFloat
  let duration: Double
  let screenHeight: CGFloat
  let onComplete: () -> Void
  
  @State private var yOffset: CGFloat = -100
  @State private var opacity: Double = 0
  
  var body: some View {
    GeometryReader { geometry in
      if let uiImage = cachedImage {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 80, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
          .opacity(opacity)
          .position(
            x: geometry.size.width * xPosition,
            y: yOffset
          )
          .onAppear {
            startAnimation()
          }
      }
    }
  }
  
  func startAnimation() {
    withAnimation(.easeIn(duration: 0.3)) {
      opacity = 1
    }
    
    withAnimation(.linear(duration: duration)) {
      yOffset = screenHeight + 100
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + duration - 1) { [opacity] in
      withAnimation(.easeOut(duration: 0.5)) {
        self.opacity = 0
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      onComplete()
    }
  }
}

struct AIImageGenTutorial: View {
  @State private var currentState: CurrentState = .intro
  
  enum CurrentState {
    case intro
    case trainingData
    case demo
  }
  
  var body: some View {
    VStack {
      switch currentState {
      case .intro:
        IntroView()
      case .trainingData:
        TrainingData()
      case .demo:
        Spacer()
      }
    }
    
    HStack {
      Button("Previous") {
        withAnimation(.bouncy) {
          switch currentState {
          case .intro:
            currentState = .demo
          case .trainingData:
            currentState = .intro
          case .demo:
            currentState = .trainingData
          }
        }
      }
      .buttonStyle(.glassProminent)
      .disabled(currentState == .intro)
      
      VStack {
        HStack {
          ForEach([CurrentState.intro, .trainingData, .demo], id: \.self) { state in
            Capsule()
              .fill(state == currentState ? Color.green : Color.gray.opacity(0.5))
              .frame(
                width: state == currentState ? 40 : 15,
                height: 15
              )
              .animation(.bouncy, value: currentState)
              .onTapGesture {
                withAnimation(.bouncy) {
                  currentState = state
                }
              }
          }
        }
      }
      .padding()
      .glassEffect(.clear.interactive(), in: .capsule)
      
      Button("Next") {
        withAnimation(.bouncy) {
          switch currentState {
          case .intro:
            currentState = .trainingData
          case .trainingData:
            currentState = .demo
          case .demo:
            currentState = .intro
          }
        }
      }
      .buttonStyle(.glassProminent)
      .disabled(currentState == .demo)
    }
  }
}

struct IntroView: View {
  var body: some View {
    Text("Welcome to the AI Image Generation Tutorial!")
      .font(.largeTitle)
      .bold()
      .padding()
      .glassEffect(.clear, in: .rect(cornerRadius: 15))
  }
}

struct TrainingData: View {
  var body: some View {
    ZStack {
      CascadingImagesView()
        .ignoresSafeArea()
      
      VStack {
        Text("How does an image generator work?")
          .font(.largeTitle)
          .bold()
          
        Text("A crucial part in generating AI images is the use of training data. The AI model is trained on a vast dataset of images, like the ones falling in the background. By analyzing these images, the model learns to recognize patterns, shapes, colors, and textures. When you provide a text prompt, the model uses this learned information to create new images that match the description. The more diverse and extensive the training data, the better the model can generate high-quality and varied images.")
      }
      .padding()
      .glassEffect(.clear, in: .rect(cornerRadius: 15))
      .padding()
    }
  }
}
