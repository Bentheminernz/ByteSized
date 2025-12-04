//
//  FallingItem.swift
//  AIEducation
//
//  Created by Ben Lawrence on 04/12/2025.
//

import Foundation
import SwiftUI

// MARK: - generic model for falling items
struct FallingItem<Content>: Identifiable {
  let id = UUID()
  let content: Content
  let xPosition: CGFloat
  let delay: Double
  let duration: Double
}

// MARK: - view for falling items
struct FallingItemsView<Content, ItemView: View>: View {
  let items: [Content]
  let itemsToShow: Int
  let spawnInterval: TimeInterval
  let durationRange: ClosedRange<Double>
  let itemBuilder: (Content) -> ItemView
  
  @State private var fallingItems: [FallingItem<Content>] = []
  @State private var screenHeight: CGFloat = 0
  @State private var timer: Timer?
  
  init(
    items: [Content],
    itemsToShow: Int = 12,
    spawnInterval: TimeInterval = 0.4,
    durationRange: ClosedRange<Double> = 6...10,
    @ViewBuilder itemBuilder: @escaping (Content) -> ItemView
  ) {
    self.items = items
    self.itemsToShow = itemsToShow
    self.spawnInterval = spawnInterval
    self.durationRange = durationRange
    self.itemBuilder = itemBuilder
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.black.opacity(0.1)
          .ignoresSafeArea()
        
        ForEach(fallingItems) { fallingItem in
          FallingItemContainer(
            content: itemBuilder(fallingItem.content),
            xPosition: fallingItem.xPosition,
            duration: fallingItem.duration,
            delay: fallingItem.delay,
            screenHeight: geometry.size.height,
            onComplete: {
              recycleItem(fallingItem)
            }
          )
        }
      }
      .onAppear {
        screenHeight = geometry.size.height
        generateInitialItems()
        startContinuousFlow()
      }
      .onDisappear {
        timer?.invalidate()
        timer = nil
      }
    }
    .drawingGroup()
  }
  
  func generateInitialItems() {
    for i in 0..<itemsToShow {
      addNewItem(delay: Double(i) * spawnInterval)
    }
  }
  
  func startContinuousFlow() {
    timer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { _ in
      addNewItem(delay: 0)
    }
  }
  
  func addNewItem(delay: Double) {
    guard let randomContent = items.randomElement() else { return }
    
    let xPosition = CGFloat.random(in: 0.1...0.9)
    let duration = Double.random(in: durationRange)
    
    let newItem = FallingItem(
      content: randomContent,
      xPosition: xPosition,
      delay: delay,
      duration: duration
    )
    
    fallingItems.append(newItem)
  }
  
  func recycleItem(_ item: FallingItem<Content>) {
    if let index = fallingItems.firstIndex(where: { $0.id == item.id }) {
      fallingItems.remove(at: index)
    }
  }
}

// MARK: - container for individual falling item animation
struct FallingItemContainer<Content: View>: View {
  let content: Content
  let xPosition: CGFloat
  let duration: Double
  let delay: Double
  let screenHeight: CGFloat
  let onComplete: () -> Void
  
  @State private var yOffset: CGFloat = -100
  @State private var opacity: Double = 0
  
  var body: some View {
    GeometryReader { geometry in
      content
        .opacity(opacity)
        .position(
          x: geometry.size.width * xPosition,
          y: yOffset
        )
        .onAppear {
          startAnimation()
        }
    }
  }
  
  func startAnimation() {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      withAnimation(.easeIn(duration: 0.3)) {
        opacity = 1
      }
      
      withAnimation(.linear(duration: duration)) {
        yOffset = screenHeight + 100
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + duration - 1) {
        withAnimation(.easeOut(duration: 0.5)) {
          opacity = 0
        }
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        onComplete()
      }
    }
  }
}
