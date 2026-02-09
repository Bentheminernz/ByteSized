//
//  HorizontalView.swift
//  ByteSized
//
//  Created by Ben Lawrence on 10/02/2026.
//

import SwiftUI

struct HorizontalView<PlaceholderContent: View, Content: View>: View {
  @State private var isLandscape = UIDevice.current.orientation.isLandscape
  
  let placeholderContent: PlaceholderContent
  let content: Content
  
  init(
    @ViewBuilder placeholder: () -> PlaceholderContent,
    @ViewBuilder content: () -> Content
  ) {
    self.placeholderContent = placeholder()
    self.content = content()
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
