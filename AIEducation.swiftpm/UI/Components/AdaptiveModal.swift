//
//  AdaptiveModal.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

import SwiftUI

/// A view modiefier that presents a sheet or fullScreenCover based on horizontal size class
struct AdaptiveModal<Modal: View>: ViewModifier {
  @Environment(\.horizontalSizeClass) private var hSize
  @Binding var isPresented: Bool
  let interactiveDismissDisabled: Bool
  let modal: () -> Modal
  
  func body(content: Content) -> some View {
    if hSize == .regular {
      content
        .sheet(isPresented: $isPresented) {
          modal()
            .interactiveDismissDisabled(interactiveDismissDisabled)
            .presentationBackgroundInteraction(.disabled)
        }
    } else {
      content
        .fullScreenCover(isPresented: $isPresented) {
          modal()
            .interactiveDismissDisabled(interactiveDismissDisabled)
        }
    }
  }
}

extension View {
  /// Presents a view either a sheet or fullScreenCover based on horizontal size class
  /// - Parameters:
  ///   - isPresented: A binding to whether the modal is presented
  ///   - interactiveDismissDisabled: A Boolean value that indicates whether interactive dismissal is disabled
  ///   - content: A view builder that creates the modal content
  /// - Returns: A view that presents the modal adaptively
  func adaptiveModal<Content: View>(
    isPresented: Binding<Bool>,
    interactiveDismissDisabled: Bool = false,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(AdaptiveModal(isPresented: isPresented, interactiveDismissDisabled: interactiveDismissDisabled, modal: content))
  }
}
