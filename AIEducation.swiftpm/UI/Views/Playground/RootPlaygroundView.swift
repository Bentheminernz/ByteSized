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
  enum currentView { case foundationModels, imagePlayground }
  
  @State private var selectedView: currentView = .foundationModels
  
  var body: some View {
    VStack {
      Picker("Select View", selection: $selectedView) {
        Text("LLM Playground").tag(currentView.foundationModels)
        Text("Image Generation Playground").tag(currentView.imagePlayground)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.horizontal)
      .padding(.top)
      
//      Divider()
      
      switch selectedView {
      case .foundationModels:
        FoundationModelsPlayground()
      case .imagePlayground:
        ImagePlaygroundView()
      }
    }
  }
}
