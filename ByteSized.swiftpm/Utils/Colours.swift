//
//  Colours.swift
//  ByteSized
//
//  Created by Ben Lawrence on 17/01/2026.
//

import Foundation
import SwiftUI

struct Colours {
  static let Icterine = Color(red: 0.38, green: 0.949, blue: 0.761)
  static let GreenYellow = Color(red: 0.761, green: 0.949, blue: 0.38)  // #c2f261
  static let LightGreen = Color(red: 0.569, green: 0.949, blue: 0.569)  // #91f291
  static let Aquamarine = Color(red: 0.38, green: 0.949, blue: 0.761)  // #61f2c2
  static let FlourescantCyan = Color(red: 0.188, green: 0.949, blue: 0.949)  // #30f2f2

  /// Pink colour used for Xcode keywords
  static func xcodeKeyword(_ colorScheme: ColorScheme) -> Color {
    return colorScheme == .dark
      ? Color(red: 0.988, green: 0.374, blue: 0.638)
      : Color(red: 0.608, green: 0.138, blue: 0.576)
  }

  /// Purple colour used for Xcode method names
  static func xcodeMethodName(_ colorScheme: ColorScheme) -> Color {
    return colorScheme == .dark
      ? Color(red: 0.631, green: 0.404, blue: 0.902)
      : Color(red: 0.422, green: 0.213, blue: 0.664)
  }

  /// Purple colour used for Xcode class names
  static func xcodeClass(_ colorScheme: ColorScheme) -> Color {
    return colorScheme == .dark
      ? Color(red: 0.816, green: 0.659, blue: 1.0)
      : Color(red: 0.225, green: 0.00, blue: 0.628)
  }
}
