//
//  ImageView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 05/11/2025.
//

import FoundationModels
import ImagePlayground
import SwiftUI
import UIKit

// MARK: - Completed

struct FallingImage: Identifiable {
  let id = UUID()
  let filename: String
  let xPosition: CGFloat
  let delay: Double
  let duration: Double
  let cachedImage: UIImage?

  static let natureImageFilenames: [String] = [
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
    "F1394BA7-8566-4E5D-A86F-F0C4EB49697F.jpeg",
  ]
}

struct CascadingImagesView: View {
  @State private var imageCache: [String: UIImage] = [:]

  var body: some View {
    FallingItemsView(items: FallingImage.natureImageFilenames) { filename in
      if let uiImage = imageCache[filename] {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 80, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
      }
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

struct ImageGeneration1: View {
  var body: some View {
    VStack(spacing: 32) {
      VStack(spacing: 16) {
        Image(systemName: "photo.on.rectangle.angled")
          .font(.system(size: 60))
          .foregroundStyle(.purple.gradient)
        
        Text("AI Image Generation")
          .font(.largeTitle.bold())
          .multilineTextAlignment(.center)
      }
      
      VStack(alignment: .leading, spacing: 20) {
        Text(
          "Throughout this app we have looked at Large Language Models, which are designed to understand and generate text. But AI can do a lot more than generate text! They can also generate images!"
        )
        .font(.title3)
        .multilineTextAlignment(.leading)

        Text(
          "You might be asking, but how?? How can it make images?? They're designed to work with text and are trained on text, so how can they create images??"
        )
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
      }
      .padding()
      .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
    .padding()
  }
}

struct ImageGeneration2: View {
  var body: some View {
    ZStack {
      CascadingImagesView()
        .ignoresSafeArea()

      VStack(spacing: 20) {
        HStack(spacing: 12) {
          Image(systemName: "sparkles")
            .font(.title2)
            .foregroundStyle(.purple)
          
          Text("Well its the exact same principle as text generation!")
            .font(.title2.bold())
            .multilineTextAlignment(.center)
          
          Image(systemName: "sparkles")
            .font(.title2)
            .foregroundStyle(.purple)
        }

        Text(
          "Just like how Large Language Models are trained on vast amounts of text data to understand patterns and relationships between words, AI image generation models, also known as, Diffusion Models, are trained on huge datasets of images. They learn to recognize patterns, colors, shapes, and objects within those images. When given a prompt, they use that learned knowledge to generate new images that match the description."
        )
        .font(.body)
        .multilineTextAlignment(.center)
      }
      .padding(24)
      .glassEffect(.regular, in: .rect(cornerRadius: 20))
      .padding()
    }
  }
}

struct ImageGeneration3: View {
  var body: some View {
    HStack(spacing: 32) {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 8) {
            Image(systemName: "questionmark.circle.fill")
              .foregroundStyle(.purple)
              .font(.title2)
            
            Text("How Does It Know?")
              .font(.title.bold())
          }
          
          Text(
            "That makes sense but, how can the diffusion model tell the difference between the sky and a cat or a tree?? Let alone know what a cat or a tree is??"
          )
          .font(.title3)
          .foregroundStyle(.primary)
        }

        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
              .foregroundStyle(.yellow)
              .font(.title3)
            
            Text("The Answer")
              .font(.headline)
          }
          
          Text(
            """
            Fantastic Question! The answer lies in the training data, usually images are bundled with descriptive text captions. These captions provide context and meaning to certain elements within the images.
            
            For example, an image might contain a car, streetlamp, and a tree, and the caption would describe their objects and their position within the image. By learning from these captions, the model can associate specific words with visual features in the images.
            """
          )
          .font(.body)
          .foregroundStyle(.secondary)
        }
      }
      .padding()
      .glassEffect(.regular, in: .rect(cornerRadius: 20))

      if let image = Bundle.main.url(
        forResource: "TrainingData",
        withExtension: "heic"
      ),
        let uiImage = UIImage(contentsOfFile: image.path)
      {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
          .frame(width: 400, height: 400)
          .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
      }
    }
    .padding()
  }
}

struct ImageGeneration4: View {
  @Environment(ImageCreatorService.self) private var imageCreatorService

  @State private var generatedImages: [CGImage?] = Array(
    repeating: nil,
    count: 5
  )
  @State private var imageStyle: ImagePlaygroundStyle = .animation

  var body: some View {
    if let isSupported = imageCreatorService.isSupported,
      isSupported
    {
      VStack(spacing: 24) {
        VStack(spacing: 16) {
          HStack(spacing: 8) {
            Image(systemName: "wand.and.stars")
              .foregroundStyle(.purple.gradient)
              .font(.title2)
            
            Text("Let's See It In Action!")
              .font(.title.bold())
          }
          
          Text(
            "Below, we'll generate some images based on this prompt:"
          )
          .font(.body)
          
          Text("\"A sunny day on a beach on a remote island. Various Palm Trees swaying in the breeze\"")
            .font(.body)
            .foregroundStyle(.purple)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(.purple.opacity(0.1))
            )
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(.purple.opacity(0.3), lineWidth: 1)
            )
        }

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 40) {
            ForEach(generatedImages.indices, id: \.self) { idx in
              Group {
                if let cgImage = generatedImages[idx] {
                  VStack(spacing: 8) {
                    Image(uiImage: UIImage(cgImage: cgImage))
                      .resizable()
                      .frame(width: 250, height: 250)
                      .clipShape(RoundedRectangle(cornerRadius: 16))
                      .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                      .intelligence(in: .rect(cornerRadius: 16), spread: 4)
                      .contextMenu {
                        Button(action: {
                          UIImageWriteToSavedPhotosAlbum(
                            UIImage(cgImage: cgImage),
                            nil,
                            nil,
                            nil
                          )
                        }) {
                          Label("Save Image", systemImage: "square.and.arrow.down")
                        }
                      }
                    
                    Text("Image \(idx + 1)")
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                } else {
                  ZStack {
                    RoundedRectangle(cornerRadius: 16)
                      .fill(Color.purple.opacity(0.05))
                      .frame(width: 250, height: 250)
                      .overlay(
                        RoundedRectangle(cornerRadius: 16)
                          .stroke(Color.purple.opacity(0.2), lineWidth: 2)
                          .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                      )
                    VStack(spacing: 12) {
                      ProgressView()
                        .tint(.purple)
                      Text("Generating…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                      Text("Image \(idx + 1)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    }
                  }
                  .frame(width: 300, height: 300)
                }
              }
            }
          }
          .padding(.horizontal)
        }

        VStack(spacing: 12) {
          HStack(spacing: 8) {
            Image(systemName: "paintpalette.fill")
              .foregroundStyle(.purple)
            
            Text(
              "Try selecting a different style below:"
            )
            .font(.headline)
          }
          
          Picker("Image Style", selection: $imageStyle) {
            Text("Animation").tag(ImagePlaygroundStyle.animation)
            Text("Illustration").tag(ImagePlaygroundStyle.illustration)
            Text("Sketch").tag(ImagePlaygroundStyle.sketch)
          }
          .pickerStyle(.segmented)
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
      }
      .padding()
      .onAppear {
        generatedImages = Array(repeating: nil, count: 5)
        Task {
          await generateImages()
        }
      }
      .onChange(of: imageStyle) {
        generatedImages = Array(repeating: nil, count: 5)
        Task {
          await generateImages()
        }
      }
    } else {
      ContentUnavailableView {
        Label(
          "Image Generation Not Supported",
          systemImage: "apple.intelligence.badge.xmark"
        )
      } description: {
        Text(
          "Sorry, Image Generation powered by Apple Intelligence is not supported on your device."
        )
        Text("Heres an example of what it would look like:")
        
        #if targetEnvironment(simulator)
          Text("Image Playground is not supported in the simulator. If possible could you test this feature on a physical device?")
        #endif
        
        if let url = Bundle.main.url(
          forResource: "AIExample",
          withExtension: "jpg"
        ),
           let uiImage = UIImage(contentsOfFile: url.path)
        {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .cornerRadius(12)
            .intelligence(in: .rect(cornerRadius: 12), spread: 4)
        }
      }
    }
  }

  private func generateImages() async {
    do {
      guard let availableStyle = imageCreatorService.availableStyles.first
      else {
        print("No available styles")
        return
      }

      let style =
        !imageCreatorService.availableStyles.contains(imageStyle)
        ? availableStyle : .animation

      let imageSequence = try await imageCreatorService.generateImages(
        for: [
          .text(
            "A sunny day on a beach on a remote island. Various Palm Trees swaying in the breeze"
          )
        ],
        style: style,
        limit: 5
      )
      for try await generated in imageSequence {
        if let emptyIndex = generatedImages.firstIndex(where: { $0 == nil }) {
          withAnimation(.bouncy) {
            generatedImages[emptyIndex] = generated.cgImage
          }
        }
      }
    } catch {
      print("Error occurred \(error)")
    }
  }
}

struct ImageGeneration5: View {
  let code = """
    import ImagePlayground
    import UIKit

    var images: [CGImage] = []
    let imageCreator = try await ImageCreator()

    let generatedImages = imageCreator.images(
      for: [.text("A sunny day on a beach on a remote island. Various Palm Trees swaying in the breeze")],
      style: .animation,
      limit: 3
    )

    for try await image in generatedImages {
      images.append(image.cgImage)
    }
    """

  let uiCode = """
    import SwiftUI

    struct ContentView: View {
      @State private var images: [CGImage] = []
      
      var body: some View {
        VStack {
          ForEach(images, id: \\.self) { image in
            Image(uiImage: UIImage(cgImage: image))
              .resizable()
              .scaledToFit()
          }
        }
      }
    }

    """

  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 12) {
        HStack(spacing: 8) {
          Image(systemName: "chevron.left.forwardslash.chevron.right")
            .foregroundStyle(.purple.gradient)
            .font(.title2)
          
          Text("Code Implementation")
            .font(.title.bold())
        }
        
        Text(
          "Just like with Apple's Foundation Models, using Image Playground is super simple! Here's an example of how to generate images programmatically:"
        )
        .font(.body)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
      }

      HStack(alignment: .top, spacing: 24) {
        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 8) {
            Image(systemName: "1.circle.fill")
              .foregroundStyle(.purple)
              .font(.title3)
            
            Text("Generate Images")
              .font(.headline)
          }
          
          Text(
            "First, you create an instance of the ImageCreator, and then you can call the images(for:style:limit:) method to generate images based on a text prompt:"
          )
          .font(.subheadline)
          .foregroundStyle(.secondary)
          
          ScrollView {
            CodeViewer(code: code, language: .swift)
          }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        
        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 8) {
            Image(systemName: "2.circle.fill")
              .foregroundStyle(.purple)
              .font(.title3)
            
            Text("Display in SwiftUI")
              .font(.headline)
          }
          
          Text("And then to display those images in a SwiftUI view, you can do something like this:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
          
          ScrollView {
            CodeViewer(code: uiCode, language: .swift)
          }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
      }
    }
    .padding()
  }
}
