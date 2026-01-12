//
//  ImagePlaygroundView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import ImagePlayground
import PhotosUI
import SwiftUI

struct ImagePlaygroundView: View {
  @State private var imageStyle: ImagePlaygroundStyle = .animation
  @State private var textPrompts: [String] = []
  @State private var imageCount: Int = 3

  @State private var selectedImages: [PhotosPickerItem] = []
  @State private var loadedImages: [UIImage] = []
  @State private var playgroundLoadedImages: [CGImage] = []
  @State private var generatedImages: [CGImage?] = []

  @State private var generationState: GenerationState = .idle
  @State private var generationError: ImageCreator.Error?

  private var fullCode: String {
    """
    import ImagePlayground

    // Creates the image creator
    let imageCreator = try await ImageCreator()

    // Generate the images
    let imageSequence = imageCreator.images(
      for: [\(playgroundLoadedImages.map { _ in ".image(yourCGImage)" }.joined(separator: ", "))
            \(textPrompts.isEmpty ? "" : (playgroundLoadedImages.isEmpty ? "" : ", "))\(textPrompts.map { ".text(\"\($0)\")" }.joined(separator: ", "))],
      style: .\(imageStyleToString(imageStyle).lowercased()),
      limit: \(imageCount)
    )

    // Iterate through the generated images
    for try await image in imageSequence {
      // Use the generated image (CGImage)
    }
    """
  }

  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        // MARK: Left Panel - Controls
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            Text("Controls")
              .font(.title2.bold())
              .padding(.bottom, 8)

            if !loadedImages.isEmpty {
              Text("Selected Reference Images")
                .font(.headline)

              ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                  ForEach(loadedImages.indices, id: \.self) { index in
                    Image(uiImage: loadedImages[index])
                      .resizable()
                      .scaledToFit()
                      .frame(height: 200)
                      .cornerRadius(8)
                      .contextMenu {
                        Button(
                          "Remove",
                          systemImage: "trash",
                          role: .destructive
                        ) {
                          loadedImages.remove(at: index)
                          playgroundLoadedImages.remove(at: index)
                        }
                      }
                  }
                }
              }
            }

            PhotosPicker(
              selection: $selectedImages,
              maxSelectionCount: 5,
              matching: .images
            ) {
              Label(
                "Select Reference Images",
                systemImage: "photo.on.rectangle.angled"
              )
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.blue.opacity(0.1))
              .cornerRadius(8)
            }
            .onChange(of: selectedImages) { oldValue, newValue in
              Task {
                loadedImages.removeAll()
                playgroundLoadedImages.removeAll()

                for item in newValue {
                  if let data = try? await item.loadTransferable(
                    type: Data.self
                  ),
                    let uiImage = UIImage(data: data)
                  {
                    loadedImages.append(uiImage)
                    if let cgImage = uiImage.cgImage {
                      playgroundLoadedImages.append(cgImage)
                    }
                  }
                }
              }
            }

            // Text Prompts
            VStack(alignment: .leading, spacing: 8) {
              ForEach(0..<textPrompts.count, id: \.self) { idx in
                HStack {
                  TextField(
                    "Enter prompt",
                    text: Binding(
                      get: { textPrompts[idx] },
                      set: { textPrompts[idx] = $0 }
                    )
                  )
                  .padding()
                  .glassEffect(.regular, in: .capsule)

                  Button(action: {
                    textPrompts.remove(at: idx)
                  }) {
                    Image(systemName: "minus.circle.fill")
                      .foregroundStyle(.red)
                  }
                }
              }

              Button("Add Text Prompt") {
                withAnimation(.bouncy) {
                  textPrompts.append("")
                }
              }
              .buttonStyle(.glass)
            }

            Text("Image Style")
              .font(.headline)
            Picker("Image Style", selection: $imageStyle) {
              Text("Animation").tag(ImagePlaygroundStyle.animation)
              Text("Sketch").tag(ImagePlaygroundStyle.sketch)
              Text("Illustration").tag(ImagePlaygroundStyle.illustration)
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading) {
              Text("Number of Images: \(imageCount)")
              Slider(
                value: Binding<Double>(
                  get: { Double(imageCount) },
                  set: { imageCount = Int($0) }
                ),
                in: 1...5,
                step: 1
              )
            }

            Spacer()

            Button(action: {
              Task {
                generationError = nil
                generatedImages = Array(repeating: nil, count: imageCount)
                let response = await generateImages()
                if let error = response {
                  generationError = error
                } else {
                  generationError = nil
                }
              }
            }) {
              Text("Generate Images")
                .font(.headline)
                .frame(maxWidth: .infinity)
            }
            .disabled(
              [.requested, .generating].contains(generationState)
                || (textPrompts.isEmpty && playgroundLoadedImages.isEmpty)
            )
            .tint(Color.green.gradient)
            .buttonStyle(.glassProminent)

            Spacer()
          }
          .padding()
          .frame(width: geometry.size.width * 0.4)
        }
        .glassEffect(.regular, in: .rect(cornerRadius: 8))

        //        Divider()

        // MARK: Right Panel - Results
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              Image(systemName: "sparkles")
                .font(.system(size: 32))
                .symbolEffect(
                  .breathe,
                  isActive: generationState == .generating
                )
                .symbolRenderingMode(.multicolor)
                .symbolColorRenderingMode(.gradient)

              Text("Model Output")
                .font(.title2).bold()
            }

            Text(generationState.modelStatusText)
              .font(.subheadline)
              .foregroundStyle(.secondary)

            if !generatedImages.isEmpty {
              Text("Generated Images")
                .font(.headline)
                .padding(.top)

              if generationError == nil {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 16) {
                    ForEach(generatedImages.indices, id: \.self) { idx in
                      Group {
                        if let cgImage = generatedImages[idx] {
                          Image(uiImage: UIImage(cgImage: cgImage))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(8)
                            .intelligence(in: .rect(cornerRadius: 8))
                            .contextMenu {
                              Button(
                                "Save",
                                systemImage: "square.and.arrow.down"
                              ) {
                                saveImageToPhotos(cgImage)
                              }
                            }
                        } else {
                          ZStack {
                            RoundedRectangle(cornerRadius: 10)
                              .fill(Color.gray.opacity(0.15))
                              .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                              )
                            VStack(spacing: 8) {
                              ProgressView()
                              Text("Loading…")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            }
                          }
                          .frame(width: 300, height: 300)
                        }
                      }
                    }
                  }
                  .padding()
                }
              } else {
                if let error = generationError {
                  Text(returnErrorMessage(for: error))
                    .foregroundStyle(.red)
                    .padding()
                }
              }
            }

            VStack(alignment: .leading) {
              HStack {
                Text("Swift Code Output")
                  .font(.headline)

                Spacer()

                Button("Copy", systemImage: "document.on.document") {
                  UIPasteboard.general.string = fullCode
                }
                .buttonStyle(.glassProminent)
                .labelStyle(.iconOnly)
                .accessibilityLabel("Copy Swift Code to Clipboard")
              }

              VStack {
                CodeViewer(code: fullCode, language: "swift")
              }
              .glassEffect(in: .rect(cornerRadius: 10))
            }

            Spacer()
          }
          .padding()
          .frame(width: geometry.size.width * 0.6)
        }
        .onChange(of: generationError) { newValue, oldValue in
          if let error = newValue {
            generatedImages = []
            print("Error generating images: \(error.localizedDescription)")
          }
        }
      }
      .ignoresSafeArea(edges: .bottom)
    }
  }

  func generateImages() async -> ImageCreator.Error? {
    generationState = .requested
    defer { generationState = .completed }

    do {
      let creator = try await ImageCreator()
      var concepts: [ImagePlaygroundConcept] = []

      for cgImage in playgroundLoadedImages {
        concepts.append(.image(cgImage))
      }
      for prompt in textPrompts {
        concepts.append(.text(prompt))
      }

      generationState = .generating
      let imageSequence = creator.images(
        for: concepts,
        style: imageStyle,
        limit: imageCount
      )

      var idx = 0
      for try await image in imageSequence {
        if idx < generatedImages.count {
          generatedImages[idx] = image.cgImage
        } else {
          generatedImages.append(image.cgImage)
        }
        idx += 1
      }
      generationState = .completed
      return nil  // success, no error
    } catch let imageError as ImageCreator.Error {
      generationState = .completed
      return imageError
    } catch {
      // Some other unexpected error
      print("Unexpected error generating images: \(error)")
      generationState = .completed
      return nil
    }
  }

  func saveImageToPhotos(_ cgImage: CGImage) {
    let uiImage = UIImage(cgImage: cgImage)
    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
  }

  func imageStyleToString(_ style: ImagePlaygroundStyle) -> String {
    switch style {
    case .animation:
      return "Animation"
    case .sketch:
      return "Sketch"
    case .illustration:
      return "Illustration"
    default:
      return "Unknown"
    }
  }

  private func returnErrorMessage(for error: ImagePlayground.ImageCreator.Error)
    -> String
  {
    switch error {
    case .backgroundCreationForbidden:
      return "Error: Background creation is forbidden."
    case .conceptsRequirePersonIdentity:
      return
        "Error: Concepts require person identity. Try adding a reference image that contains a person."
    case .creationCancelled:
      return "Error: Image creation was cancelled."
    case .creationFailed:
      return
        "Error: Creation of the image failed. This could be caused by a bad reference isssue or prompt, try play around with different images and prompts. Sorry!"
    case .faceInImageTooSmall:
      return
        "Error: Face in image is too small. Try using a higher resolution reference image."
    case .notSupported:
      return "Error: Image creation is not supported on this device."
    case .unavailable:
      return
        "Error: Image creation service is currently unavailable. Please try again later."
    case .unsupportedInputImage:
      return "Error: Unsupported input image. Please try a different image."
    case .unsupportedLanguage:
      return "Error: Unsupported language for text prompts. Please use English."
    default:
      return "Error: An unknown error occurred during image generation."
    }
  }
}
