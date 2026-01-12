//
//  VideoTimeEventModifier.swift
//  AIEducation
//
//  Created by Ben Lawrence on 16/11/2025.
//

import AVKit
import SwiftUI

struct VideoTimeEventModifier: ViewModifier {
  let player: AVPlayer
  let time: CMTime
  let action: () -> Void

  @State private var triggered: Bool = false
  @State private var timeObserverToken: Any?

  func body(content: Content) -> some View {
    content
      .onAppear {
        addObserver()
      }
      .onDisappear {
        if let token = timeObserverToken {
          player.removeTimeObserver(token)
          timeObserverToken = nil
        }
      }
  }

  private func addObserver() {
    let interval = CMTime(seconds: 0.05, preferredTimescale: 600)

    let token = player.addPeriodicTimeObserver(
      forInterval: interval,
      queue: .main
    ) { current in
      Task { @MainActor in
        if !triggered, current >= time {
          triggered = true
          action()
        }
      }
    }
    self.timeObserverToken = token
  }
}

extension View {
  func onVideoTime(
    _ seconds: Double,
    _ player: AVPlayer,
    perform action: @escaping () -> Void
  ) -> some View {
    let cmtime = CMTime(seconds: seconds, preferredTimescale: 1000)
    return self.modifier(
      VideoTimeEventModifier(player: player, time: cmtime, action: action)
    )
  }
}
