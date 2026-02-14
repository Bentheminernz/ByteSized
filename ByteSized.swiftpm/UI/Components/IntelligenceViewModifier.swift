//
//  IntelligenceViewModifier.swift
//  AIEduation
//
//  Created by Ben Lawrence on 06/11/2025.
//

import SwiftUI

private let colors: [Color] = [
  .blue, .purple, .red, .orange, .yellow, .cyan, .blue, .purple,
]

struct IntelligenceViewModifier<S: Shape>: ViewModifier {
  @State private var offset: CGFloat = 0

  var shape: S
  var spread: CGFloat
  var blur: CGFloat

  func body(content: Content) -> some View {
    content
      .background {
        shape
          .fill(
            LinearGradient(
              colors: colors,
              startPoint: UnitPoint(x: offset, y: 0),
              endPoint: UnitPoint(x: CGFloat(colors.count) + offset, y: 0)
            )
          )
          .padding(-spread)
          .blur(radius: blur)
          .onAppear {
            withAnimation(
              .linear(duration: 10).repeatForever(autoreverses: false)
            ) {
              offset = -CGFloat(colors.count - 1)
            }
          }
      }
  }
}

extension View {
  public func intelligence<S: Shape>(
    in shape: S,
    spread: CGFloat = 0,
    blur: CGFloat = 8
  ) -> some View {
    modifier(IntelligenceViewModifier(shape: shape, spread: spread, blur: blur))
  }
}
