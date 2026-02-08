//
//  DefinableText.swift
//  AIEducation
//
//  Created by Ben Lawrence on 21/11/2025.
//

import SwiftUI

struct DefinableText: View {
  private let text: String
  private let definitions: [String: String]
  @State private var showingPopover: Bool = false
  @State private var selectedWord = ""
  @State private var popoverPosition: CGPoint = .zero

  private static let defaultDefinitions: [String: String] = [
    "ai":
      "Artificial Intelligence, the simulation of human intelligence in machines.",
    "model": "A representation or simulation of a system or process.",
    "swiftui":
      "A framework for building user interfaces for Apple platforms using Swift.",
    "tokens":
      "The fundamental unit of text or data that the model uses for processing, analysis and, generation.",
    "neural networks":
      "A series of algorithms that mimic the operations of a human brain to recognise relationships between vast amounts of data.",
    "loss":
      "A number that measures how wrong the model’s predictions are. Lower is better.",
    "epoch": "One full pass through the training data.",
    "parameters":
      "The adjustable values inside the model (like a, b, c) that change during training.",
    "gradient":
      "The direction and magnitude to change parameters to reduce loss.",
    "learning rate": "How big a step the model takes when updating parameters.",
    "overfitting":
      "When a model memorises training data but fails to generalise to new data.",
    "underfitting":
      "When a model is too simple to capture the underlying pattern.",
    "dataset": "The collection of examples used for training or evaluation.",
    "noise":
      "Random variation added to data to simulate real-world imperfections.",
    "mse":
      "Mean Squared Error, an average of squared differences between predictions and true values.",
    "curve":
      "The function the model draws to represent its predictions over x.",
    "prediction": "The output the model produces for a given input.",
    "training": "The process of adjusting parameters to reduce loss.",
    "validation":
      "Evaluating the model on held-out data to check generalisation.",
    "llm":
      "Large Language Model, a type of AI model designed to understand and generate human-like text.",
    "json":
      "JavaScript Object Notation, a lightweight data format that is easy for humans to read and write, and easy for machines to parse and generate.",
    "system instruction":
      "A special prompt that sets the behavior and guidelines for how the model should respond.",
  ]

  init(_ text: String, definitions: [String: String]? = nil) {
    self.text = text
    self.definitions = definitions ?? Self.defaultDefinitions
  }

  var body: some View {
    textView
      .overlay(
        ZStack {
          if showingPopover {
            popoverOverlay
              .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                  showingPopover = false
                }
              }
          }
        }
      )
  }

  private var textView: some View {
    Text(buildAttributedText())
      .environment(
        \.openURL,
        OpenURLAction { url in
          handleWordTap(url)
          return .handled
        }
      )
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onEnded { value in
            popoverPosition = CGPoint(
              x: value.location.x - 10,
              y: value.location.y - 20
            )
          }
      )
  }

  private var popoverOverlay: some View {
    GeometryReader { geometry in
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          showingPopover = false
        }
        .overlay(alignment: .topLeading) {
          let clampedY = max(0, min(popoverPosition.y, geometry.size.height))
          let clampedX = max(
            0,
            min(popoverPosition.x, geometry.size.width - 250)
          )
          DefinitionBubble(
            word: selectedWord,
            definition: definitions[selectedWord.lowercased()]
              ?? "No definition found"
          )
          .frame(height: clampedY.isFinite ? clampedY : 0, alignment: .bottom)
          .offset(x: clampedX.isFinite ? clampedX : 0)
          .transition(.scale.combined(with: .opacity))
        }
    }
  }

  private func buildAttributedText() -> AttributedString {
    var result = AttributedString()
    let words = text.split(separator: " ", omittingEmptySubsequences: false)
    var seenDefinedWords = Set<String>()  // track first occurrences only

    for (index, word) in words.enumerated() {
      let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
      let key = cleanWord.lowercased()
      var wordString = AttributedString(String(word))

      if definitions.keys.contains(where: { $0.lowercased() == key })
        && !seenDefinedWords.contains(key)
      {
        // only first occurrence gets link and underline
        wordString.underlineStyle = .single
        wordString.foregroundColor = .blue
        wordString.link = URL(string: "define://\(cleanWord)")
        seenDefinedWords.insert(key)
      }

      result.append(wordString)
      if index < words.count - 1 {
        result.append(AttributedString(" "))
      }
    }

    return result
  }

  private func handleWordTap(_ url: URL) {
    guard url.scheme == "define",
      let word = url.host
    else { return }

    selectedWord = word

    withAnimation(.spring(response: 0.3)) {
      showingPopover = true
    }
  }
}

struct DefinitionBubble: View {
  let word: String
  let definition: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(word)
        .font(.headline)
        .foregroundStyle(.primary)

      Text(definition)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding()
    .frame(maxWidth: 250)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(uiColor: .systemBackground))
        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color(uiColor: .separator), lineWidth: 1)
    )
  }
}
