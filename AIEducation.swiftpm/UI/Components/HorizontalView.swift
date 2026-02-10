//
//  HorizontalView.swift
//  ByteSized
//
//  Created by Ben Lawrence on 10/02/2026.
//

import SwiftUI

/// A view that displays different content based on device orientation (landscape or portrait).
/// - Parameters:
///   - content: The view to display when the device is in landscape orientation.
///   - placeholderContent: The view to display when the device is in portrait orientation.
struct HorizontalView<Content: View, PlaceholderContent: View>: View {
  @State private var isLandscape = UIDevice.current.orientation.isLandscape
  
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
    Group {
      if isLandscape {
        content
      } else {
        placeholderContent
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
      isLandscape = UIDevice.current.orientation.isLandscape
    }
    .onAppear {
      isLandscape = UIDevice.current.orientation.isLandscape
    }
  }
}

//struct SmallWindowView<Content: View, PlaceholderContent
