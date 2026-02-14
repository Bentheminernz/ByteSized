//
//  CleanVideoPlayer.swift
//  ByteSized
//
//  Created by Ben Lawrence on 16/11/2025.
//

import AVKit
import MediaPlayer
import SwiftUI

struct CleanVideoPlayer: UIViewRepresentable {
  let player: AVPlayer

  func makeUIView(context: Context) -> UIView {
    configureAudioSession()
    clearNowPlayingInfo()

    let view = PlayerContainerView()
    view.player = player
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}

  private func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.ambient)
    try? session.setActive(true)
  }

  private func clearNowPlayingInfo() {
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nil  // super important for hiding from now playing. TODO: check if it causes any issues

    let remote = MPRemoteCommandCenter.shared()
    remote.playCommand.isEnabled = false
    remote.pauseCommand.isEnabled = false
    remote.togglePlayPauseCommand.isEnabled = false
  }
}

class PlayerContainerView: UIView {
  var player: AVPlayer? {
    didSet { (layer as? AVPlayerLayer)?.player = player }
  }

  override class var layerClass: AnyClass { AVPlayerLayer.self }
}

extension AVPlayer {
  func addTimeObserver(
    at seconds: Double,
    action: @Sendable @escaping () -> Void
  ) {
    let time = CMTime(seconds: seconds, preferredTimescale: 600)

    self.addBoundaryTimeObserver(
      forTimes: [NSValue(time: time)],
      queue: .main,
      using: action
    )
  }
}
