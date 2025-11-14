//
//  Welcome.swift
//  AIEduation
//
//  Created by Ben Lawrence on 14/11/2025.
//

import SwiftUI

struct Welcome: View {
  @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  var body: some View {
    VStack {
      WelcomePageHeader(
        title: "Welcome to AIEducation",
        subtitle: "Your gateway to learning about AI and its applications.",
        imageName: "graduationcap.fill",
      )
      
      Spacer()
      
      VStack(alignment: .leading) {
        WelcomePoint(
          title: "Explore AI Concepts",
          description: "Dive into the fundamentals of artificial intelligence, machine learning, and deep learning.",
          imageName: "brain.head.profile"
        )
        
        WelcomePoint(
          title: "Hands-on Lessons",
          description: "Engage with interactive lessons that make learning AI fun and practical.",
          imageName: "book.fill"
        )
        
        WelcomePoint(
          title: "Powered by Apple Intelligence",
          description: "Experience the cutting-edge capabilities of Apple Intelligence to enhance your learning journey.",
          imageName: "apple.intelligence"
        )
      }
      
      Spacer()
      Spacer()
      
      Button(action: {
        hasSeenWelcome = true
        dismiss()
      }) {
        Text("Let's Go!")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
      }
      .tint(.accentColor)
      .buttonStyle(.glassProminent)
    }
    .frame(maxWidth: horizontalSizeClass == .compact ? .infinity : 500)
  }
  
  @ViewBuilder
  func WelcomePoint(title: String, description: String, imageName: String) -> some View {
    HStack {
      Image(systemName: imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
        .foregroundStyle(.green.gradient)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.title3)
          .fontWeight(.bold)
        
        Text(description)
          .font(.body)
          .foregroundStyle(.secondary)
      }
      .padding()
    }
  }
  
  @ViewBuilder
  func WelcomePageHeader(title: String, subtitle: String, imageName: String, imageColor: Color = .accentColor) -> some View {
    VStack(spacing: 16) {
      Image(systemName: imageName)
        .font(.system(size: 72))
        .foregroundStyle(.white)
        .frame(width: 114, height: 114)
        .background(imageColor.gradient)
        .cornerRadius(20)
        .padding(.bottom, 5)
      
      
      VStack {
        Text(title)
          .font(.title)
          .fontWeight(.bold)
        
        Text(subtitle)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .padding()
  }
}
