//
//  04-TokensContextLesson.swift
//  AIEducation
//
//  Created by Ben Lawrence on 17/11/2025.
//

import SwiftUI

// MARK: - WIP

struct TokenContextLesson1: View {
  @State private var tokenizer: Tokenizer = Tokenizer()
  @State private var inputText: String = ""
  @State private var tokens: [Token] = []
  @State private var viewState: ViewState = .text
  @State private var visibleDemoText: String = ""
  @State private var timer: Timer?

  enum ViewState { case text, token }

  var fullDemoText = "The quick brown fox jumps over the lazy dog."

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack {
        Text(
          "Large Language Models process text by breaking it down into smaller units called tokens. These tokens can represent words, subwords, or even individual characters depending on the tokenizer used. Understanding tokenization is crucial for working effectively with LLMs. These tokens can be represented as text or numerical IDs that the model uses for processing."
        )
        .font(.body)
        .foregroundStyle(.secondary)

        Text(
          "For example take this sentence, \"\(fullDemoText)\". If we throw it into a tokenizer we get the following tokens:"
        )
        .font(.body)
        .foregroundStyle(.secondary)

        WrapLayout(spacing: 6) {
          ForEach(tokenizer.tokenize(visibleDemoText).indices, id: \.self) {
            index in
            switch viewState {
            case .text:
              TokenChip(
                text: tokenizer.tokenize(visibleDemoText)[index].text,
                color: TokenChip.color(for: index)
              )
            case .token:
              TokenChip(
                text: String(
                  tokenizer.tokenize(visibleDemoText)[index].tokenID
                ),
                color: .clear,
                border: .secondary
              )
            }
          }
        }
      }

      TextField("Enter text to tokenize", text: $inputText)
        .padding()
        .glassEffect(.regular.interactive(), in: .capsule)
        .padding(.top)

      Text("Amount of Tokens: \(tokens.count)")
        .contentTransition(.numericText(value: Double(tokens.count)))

      Picker("View Mode", selection: $viewState) {
        Text("Text View").tag(ViewState.text)
        Text("Token IDs").tag(ViewState.token)
      }

      WrapLayout(spacing: 6) {
        ForEach(tokens.indices, id: \.self) { index in
          switch viewState {
          case .text:
            TokenChip(
              text: tokens[index].text,
              color: TokenChip.color(for: index)
            )
          case .token:
            TokenChip(
              text: String(tokens[index].tokenID),
              color: .clear,
              border: .secondary
            )
          }
        }
      }

      Spacer()
    }
    .padding()
    .onChange(of: inputText) {
      withAnimation(.bouncy) {
        tokens = tokenizer.tokenize(inputText)
      }
    }
    .onAppear {
      startTextAnimation()
    }
    .animation(.bouncy, value: viewState)
  }

  private func startTextAnimation() {
    visibleDemoText = ""
    let totalDuration: TimeInterval = 4.0
    let characterCount = fullDemoText.count
    let intervalTime = totalDuration / Double(characterCount)
    var currentIndex = 0

    timer = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: true)
    { timer in
      if currentIndex < fullDemoText.count {
        let index = fullDemoText.index(
          fullDemoText.startIndex,
          offsetBy: currentIndex
        )
        withAnimation(.bouncy) {
          visibleDemoText.append(fullDemoText[index])
        }
        currentIndex += 1
      } else {
        timer.invalidate()
      }
    }
  }
}

struct TokenContextLesson2: View {
  var body: some View {
    VStack {
      Text(
        "LLMs don't remember everythingn forever, they only 'see' a limited amount of text at once. This visible area is called the Context Window"
      )
      .font(.body)
      .foregroundStyle(.secondary)

      DefinableText(
        "Think of it like a chat history the model can read, everything is inside that window, your messages, the model's replies and any hidden system instructions is made up of tokens"
      )
      TripleCircleDiagram()
    }
  }
}

struct WrapLayout: Layout {
  var spacing: CGFloat = 6

  struct Cache {}

  func makeCache(subviews: Subviews) -> Cache { Cache() }

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> CGSize {
    let maxWidth = proposal.width ?? .infinity
    var x: CGFloat = 0
    var y: CGFloat = 0
    var lineHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(ProposedViewSize.unspecified)
      if x + size.width > maxWidth {
        x = 0
        y += lineHeight + spacing
        lineHeight = 0
      }
      lineHeight = max(lineHeight, size.height)
      x += size.width + spacing
    }

    return CGSize(
      width: maxWidth == .infinity ? x : maxWidth,
      height: y + lineHeight
    )
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) {
    let maxWidth = bounds.width
    var x: CGFloat = 0
    var y: CGFloat = 0
    var lineHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(ProposedViewSize.unspecified)
      if x + size.width > maxWidth {
        x = 0
        y += lineHeight + spacing
        lineHeight = 0
      }
      view.place(
        at: CGPoint(
          x: bounds.minX + x,
          y: bounds.minY + y
        ),
        proposal: ProposedViewSize(
          width: size.width,
          height: size.height
        )
      )
      lineHeight = max(lineHeight, size.height)
      x += size.width + spacing
    }
  }
}

struct TokenChip: View {
  let text: String
  var color: Color
  var border: Color? = nil

  var body: some View {
    Text(text)
      .font(.body)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(color.opacity(color == .clear ? 0 : 0.25))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(border ?? .clear, lineWidth: border == nil ? 0 : 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
  }

  static func color(for index: Int) -> Color {
    let palette: [Color] = [
      .blue, .green, .orange, .pink, .purple, .teal, .indigo, .red, .mint,
      .brown,
    ]
    return palette[index % palette.count]
  }
}

struct TripleCircleDiagram: View {
  let outerDiameter: CGFloat = 220
  let innerDiameter: CGFloat = 80
  let label: String = "lorem ipsum"

  var body: some View {
    ZStack {
      // Outer circle container
      Circle()
        .strokeBorder(.secondary.opacity(0.5), lineWidth: 2)
        .frame(width: outerDiameter, height: outerDiameter)
        .overlay(
          Circle()
            .fill(.ultraThinMaterial)
            .overlay(
              Text("Context Window")
            )
        )

      // Inner circles
      innerCircle(label)
        .offset(y: -outerDiameter * 0.33)  // Top

      innerCircle(label)
        .offset(x: -outerDiameter * 0.22, y: outerDiameter * 0.25)  // Bottom-left

      innerCircle(label)
        .offset(x: outerDiameter * 0.22, y: outerDiameter * 0.25)  // Bottom-right
    }
    .frame(width: outerDiameter, height: outerDiameter)
    .accessibilityElement(children: .contain)
    .accessibilityLabel(
      "Three circles arranged inside a larger circle: top, bottom left, and bottom right."
    )
  }

  @ViewBuilder
  private func innerCircle(_ text: String) -> some View {
    Circle()
      .fill(.regularMaterial)
      .overlay(
        Circle()
          .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
      )
      .shadow(radius: 2, y: 1)
      .frame(width: innerDiameter, height: innerDiameter)
      .overlay(
        Text(text)
          .font(.caption)
          .multilineTextAlignment(.center)
          .padding(8)
      )
  }
}
