//
//  CodeView.swift
//  AIEducation
//
//  Created by Ben Lawrence on 23/11/2025.
//

import HighlightSwift
import SwiftUI

struct CodeViewer: View {
  let code: String
  let language: Language
  var fontSize: CGFloat = 16
  var lineFontSize: CGFloat = 16

  enum Language: CaseIterable {
    case swift
    case json

    var color: Color {
      switch self {
      case .swift:
        return Color(red: 241 / 255, green: 101 / 255, blue: 41 / 255)
      case .json:
        return .blue
      }
    }

    var icon: String {
      switch self {
      case .swift:
        return "swift"
      case .json:
        return "curlybraces"
      }
    }
    
    var name: String {
      switch self {
      case .swift:
        return "Swift"
      case .json:
        return "JSON"
      }
    }
  }

  @Environment(\.colorScheme) private var colorScheme
  @State private var highlighted: AttributedString?

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      VStack(alignment: .trailing, spacing: 0) {
        ForEach(0..<lineCount, id: \.self) { index in
          Text("\(index + 1)")
            .font(.system(size: lineFontSize, design: .monospaced))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .frame(height: lineHeight, alignment: .topTrailing)
        }
      }
      .padding(.vertical, 8)
      .background(.ultraThinMaterial)

      ScrollView(.horizontal) {
        VStack(alignment: .leading, spacing: 0) {
          if highlighted != nil {
            ForEach(Array(highlightedLines.enumerated()), id: \.0) { _, line in
              Text(line)
                .font(.system(size: fontSize, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: lineHeight, alignment: .topLeading)
            }
          } else {
            ForEach(plainLines, id: \.self) { line in
              Text(line)
                .font(.system(size: fontSize, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: lineHeight, alignment: .topLeading)
            }
          }
        }
        .padding(.vertical, 8)
        .padding(.leading, 8)
        .padding(.trailing, 12)
      }
      .overlay(alignment: .topTrailing) {
        Label(language.name, systemImage: language.icon)
          .foregroundStyle(.white)
          .padding(8)
          .glassEffect(.regular.tint(language.color), in: .capsule)
          .padding(8)
      }
    }
    .accessibilityLabel("A code block in \(language.name) with \(lineCount) lines")
    .task(id: taskID) {
      await highlightNow()
    }
    .onChange(of: colorScheme) {
      Task { await highlightNow() }
    }
  }

  private var taskID: String {
    "\(language)|\(colorScheme == .dark ? "dark" : "light")|\(code.hashValue)"
  }
  private var lineHeight: CGFloat { 22 }
  private var plainLines: [String] {
    code.split(separator: "\n", omittingEmptySubsequences: false).map(
      String.init
    )
  }
  private var lineCount: Int {
    highlighted != nil ? highlightedLines.count : plainLines.count
  }

  private var highlightedLines: [AttributedString] {
    guard let highlighted else { return [] }
    var result: [AttributedString] = []
    var current = AttributedString()
    for run in highlighted.runs {
      let substring = highlighted[run.range]
      let pieces = String(substring.characters).split(
        separator: "\n",
        omittingEmptySubsequences: false
      )
      if pieces.count <= 1 {
        current += substring
      } else {
        for (i, piece) in pieces.enumerated() {
          var attributedPiece = AttributedString(String(piece))
          attributedPiece.mergeAttributes(run.attributes)
          current += attributedPiece
          if i < pieces.count - 1 {
            result.append(current)
            current = AttributedString()
          }
        }
      }
    }
    result.append(current)
    return result
  }

  private func highlightNow() async {
    do {
      let highlighter = Highlight()
      let attributed = try await highlighter.attributedText(
        code,
        language: language.name.lowercased(),
        colors: colorScheme == .dark ? .dark(.xcode) : .light(.xcode)
      )
      highlighted = attributed
    } catch {
      print("Error generating Swift code highlight: \(error)")
      highlighted = nil
    }
  }
}
