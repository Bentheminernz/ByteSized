//
//  PlaygroundView.swift
//  AIEduation
//
//  Created by Ben Lawrence on 13/11/2025.
//

import SwiftUI
import FoundationModels
import ImagePlayground
import PhotosUI

struct PlaygroundView: View {
  enum currentView { case llm, image }
  
  @State private var selectedView: currentView = .llm
  
  var body: some View {
    VStack {
      Picker("Select View", selection: $selectedView) {
        Text("LLM Playground").tag(currentView.llm)
        Text("Image Generation Playground").tag(currentView.image)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.horizontal)
      .padding(.top)
      
//      Divider()
      
      switch selectedView {
      case .llm:
        LLMPlaygroundView()
      case .image:
        ImagePlaygroundView()
      }
    }
  }
}

struct LLMPlaygroundView: View {
  let session: LanguageModelSession
  
  init(session: LanguageModelSession = LanguageModelSession()) {
    self.session = session
  }
  
  @State private var generationOptions: GenerationOptions = GenerationOptions()
  @State private var userInput: String = "Hello there! Can you tell me a joke?"
  @State private var modelOutput: String = ""
  @State private var generationStatus: GenerationState = .idle
  
  enum GenerationState {
    case idle
    case requested
    case generating
    case completed
  }
  
  var modelStatusText: String {
    switch generationStatus {
    case .idle: return ""
    case .requested: return "Preparing..."
    case .generating: return "Generating..."
    case .completed: return "Completed"
    }
  }
  
  var body: some View {
    VStack(spacing: 24) {
      Slider(
        value: Binding<Double>(
          get: { generationOptions.temperature ?? 0.5 },
          set: { generationOptions.temperature = $0 }
        ),
        in: 0.0...1.0,
        step: 0.1
      ) {
        Text("Temperature: \(String(format: "%.1f", generationOptions.temperature ?? 0.5))")
      } minimumValueLabel: {
        Text("0.0")
      } maximumValueLabel: {
        Text("1.0")
      }
      
      Slider(
        value: Binding<Double>(
          get: { Double(generationOptions.maximumResponseTokens ?? 1) },
          set: { generationOptions.maximumResponseTokens = Int($0) }
        ),
        in: 1...1000,
        step: 1
      ) {
        Text("Max Response Tokens: \(generationOptions.maximumResponseTokens ?? 1)")
      } minimumValueLabel: {
        Text("1")
      } maximumValueLabel: {
        Text("1000")
      }
            
      TextField("Enter your prompt here", text: $userInput)
        .padding()
        .glassEffect(.clear.interactive(), in: .capsule)
      
      Button("Generate") {
        Task { await generateResponse() }
      }
      .buttonStyle(.borderedProminent)
      
      if !modelOutput.isEmpty || !modelStatusText.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          if !modelStatusText.isEmpty {
            Text(modelStatusText)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          
          ScrollView {
            Text(modelOutput)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 12))
        .intelligence(shape: .rect(cornerRadius: 12))
      }
      
      Spacer()
    }
    .padding()
  }
  
  private func generateResponse() async {
    generationStatus = .requested
    do {
      let response = session.streamResponse(
        to: userInput,
        options: generationOptions
      )
      generationStatus = .generating
      
      for try await content in response {
        withAnimation(.bouncy) {
          modelOutput = content.content
        }
      }
      generationStatus = .completed
    } catch {
      print("Error during generation: \(error)")
      generationStatus = .completed
    }
  }
}
struct ImagePlaygroundView: View {
  @State private var imageStyle: ImagePlaygroundStyle = .animation
  @State private var textPrompts: [String] = []
  @State private var imageCount: Int = 3
  
  @State private var selectedImages: [PhotosPickerItem] = []
  @State private var loadedImages: [UIImage] = []
  @State private var playgroundLoadedImages: [CGImage] = []
  @State private var generatedImages: [CGImage?] = []
  
  @State private var isGenerating: Bool = false
  @State private var generationError: ImageCreator.Error?
  
  var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        // MARK: Left Panel - Controls
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            Text("Controls")
              .font(.title2.bold())
              .padding(.bottom, 8)
            
            PhotosPicker(
              selection: $selectedImages,
              maxSelectionCount: 5,
              matching: .images
            ) {
              Label("Select Reference Images", systemImage: "photo.on.rectangle.angled")
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
                  if let data = try? await item.loadTransferable(type: Data.self),
                     let uiImage = UIImage(data: data) {
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
                  TextField("Enter prompt", text: Binding(
                    get: { textPrompts[idx] },
                    set: { textPrompts[idx] = $0 }
                  ))
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
            .disabled(isGenerating || (textPrompts.isEmpty && playgroundLoadedImages.isEmpty))
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
            if !loadedImages.isEmpty {
              Text("Selected Reference Images")
                .font(.headline)
                .padding(.top)
              
              ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                  ForEach(loadedImages.indices, id: \.self) { index in
                    Image(uiImage: loadedImages[index])
                      .resizable()
                      .scaledToFit()
                      .frame(height: 200)
                      .cornerRadius(8)
                      .contextMenu {
                        Button("Remove", systemImage: "trash", role: .destructive) {
                          loadedImages.remove(at: index)
                          playgroundLoadedImages.remove(at: index)
                        }
                      }
                  }
                }
              }
            }
            
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
                            .contextMenu {
                              Button("Save", systemImage: "square.and.arrow.down") {
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
                }
              } else {
                if let error = generationError {
                  switch error {
                  case .backgroundCreationForbidden:
                    Text("Error: Background creation is forbidden.")
                  case .conceptsRequirePersonIdentity:
                    Text("Error: Concepts require person identity. Try adding a reference image that contains a person.")
                  case .creationCancelled:
                    Text("Error: Image creation was cancelled.")
                  case .creationFailed:
                    Text("Error: Creation of the image failed. This could be caused by a bad reference isssue or prompt, try play around with different images and prompts. Sorry!")
                  case .faceInImageTooSmall:
                    Text("Error: Face in image is too small. Try using a higher resolution reference image.")
                  case .notSupported:
                    Text("Error: Image creation is not supported on this device.")
                  case .unavailable:
                    Text("Error: Image creation service is currently unavailable. Please try again later.")
                  case .unsupportedInputImage:
                    Text("Error: Unsupported input image. Please try a different image.")
                  case .unsupportedLanguage:
                    Text("Error: Unsupported language for text prompts. Please use English.")
                  default:
                    Text("Error: An unknown error occurred during image generation.")
                  }
                }
              }
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
      .edgesIgnoringSafeArea(.bottom)
    }
  }
  
  func generateImages() async -> ImageCreator.Error? {
    isGenerating = true
    defer { isGenerating = false } // ensure this is always reset
    
    do {
      let creator = try await ImageCreator()
      var concepts: [ImagePlaygroundConcept] = []
      
      for cgImage in playgroundLoadedImages {
        concepts.append(.image(cgImage))
      }
      for prompt in textPrompts {
        concepts.append(.text(prompt))
      }
      
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
      
      return nil // success, no error
    } catch let imageError as ImageCreator.Error {
      return imageError
    } catch {
      // Some other unexpected error
      print("Unexpected error generating images: \(error)")
      return nil
    }
  }
  
  func saveImageToPhotos(_ cgImage: CGImage) {
    let uiImage = UIImage(cgImage: cgImage)
    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
  }
}
