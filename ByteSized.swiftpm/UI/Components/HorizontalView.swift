//
//  HorizontalView.swift
//  ByteSized
//
//  Created by Ben Lawrence on 10/02/2026.
//

import SwiftUI

/// A view that displays different content based on interface orientation (landscape or portrait).
/// Uses the view's geometry to determine orientation based on width vs height.
/// - Parameters:
///   - content: The view to display when the interface is in landscape orientation.
///   - placeholderContent: The view to display when the interface is in portrait orientation.
struct HorizontalView<Content: View, PlaceholderContent: View>: View {
  let content: Content
  let placeholderContent: PlaceholderContent
  
  init(
    @ViewBuilder content: () -> Content,
    @ViewBuilder placeholder: () -> PlaceholderContent,
  ) {
    self.content = content()
    self.placeholderContent = placeholder()
  }
  
  var body: some View {
    GeometryReader { geometry in
      if geometry.size.width > geometry.size.height {
        content
          .frame(width: geometry.size.width, height: geometry.size.height)
      } else {
        placeholderContent
          .frame(width: geometry.size.width, height: geometry.size.height)
      }
    }
  }
}

//struct SmallWindowView<Content: View, PlaceholderContent
