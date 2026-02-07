//
//  08-AISafetyBias.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: Completed

import SwiftUI

struct AISafetyBias1: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("What is AI Bias?")
        .font(.title.bold())
      
      Text(
        "AI bias happens when an AI system makes unfair or inaccurate decisions based on the data it was trained on. Just like humans can have unconscious biases, AI can too!"
      )
      .font(.title3)
      
      Text(
        "Here's the thing: AI learns from examples. If those examples are biased or incomplete, the AI will learn those biases too. It's kind of like if you only ever ate pizza from one restaurant - you might think ALL pizza tastes like that!"
      )
      .foregroundStyle(.secondary)
      
      HStack(spacing: 40) {
        VStack {
          Image(systemName: "person.2.fill")
            .font(.system(size: 60))
            .foregroundStyle(.blue)
          Text("Training Data")
            .font(.headline)
          Text("The information AI learns from")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .foregroundStyle(.secondary)
        
        VStack {
          Image(systemName: "brain")
            .font(.system(size: 60))
            .foregroundStyle(.purple)
          Text("AI Model")
            .font(.headline)
          Text("Learns patterns from data")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .foregroundStyle(.secondary)
        
        VStack {
          Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 60))
            .foregroundStyle(.orange)
          Text("Potential Bias")
            .font(.headline)
          Text("Unfair patterns get learned")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
      .padding(.top, 20)
    }
    .padding(.horizontal)
  }
}

struct AISafetyBias2: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Real-World Examples of AI Bias")
        .font(.title.bold())
      
      VStack(alignment: .leading, spacing: 25) {
        BiasExampleCard(
          icon: "camera.fill",
          color: .blue,
          title: "Facial Recognition",
          description: "Some facial recognition systems work better on certain skin tones because they were trained mostly on photos of people with lighter skin. This means they might not recognize everyone equally well.",
          impact: "People with darker skin tones may not be recognized accurately"
        )
        
        BiasExampleCard(
          icon: "briefcase.fill",
          color: .green,
          title: "Job Applications",
          description: "An AI screening resumes might favor candidates from certain schools or backgrounds if the training data mostly included people from those backgrounds who were hired in the past.",
          impact: "Qualified candidates might be unfairly overlooked"
        )
        
        BiasExampleCard(
          icon: "magnifyingglass",
          color: .purple,
          title: "Search Results",
          description: "When you search for jobs like 'CEO' or 'engineer,' the AI might show mostly images of men because that's what appeared most often in its training data, even though people of all genders do these jobs.",
          impact: "Reinforces stereotypes about who can do certain jobs"
        )
      }
    }
    .padding(.horizontal)
  }
}

struct BiasExampleCard: View {
  let icon: String
  let color: Color
  let title: String
  let description: String
  let impact: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 15) {
      Image(systemName: icon)
        .font(.system(size: 40))
        .foregroundStyle(color)
        .frame(width: 60)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.headline)
        
        Text(description)
          .font(.body)
        
        HStack {
          Image(systemName: "arrow.right.circle.fill")
            .foregroundStyle(.orange)
          Text(impact)
            .font(.caption)
            .foregroundStyle(.secondary)
            .italic()
        }
      }
    }
    .padding()
    .background(color.opacity(0.1))
    .cornerRadius(12)
  }
}

struct AISafetyBias3: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("How Do We Make AI Safer and Fairer?")
        .font(.title.bold())
      
      Text(
        "The good news is that people are working hard to make AI more fair! Here are some ways developers and researchers are tackling AI bias:"
      )
      .foregroundStyle(.secondary)
      
      VStack(spacing: 15) {
        SafetyStrategyCard(
          number: 1,
          title: "Diverse Training Data",
          description: "Using data that represents many different types of people, backgrounds, and perspectives so the AI learns from a more complete picture of the world.",
          color: .blue
        )
        
        SafetyStrategyCard(
          number: 2,
          title: "Testing for Fairness",
          description: "Checking the AI's decisions across different groups of people to make sure it's treating everyone fairly. If problems are found, the AI is adjusted.",
          color: .green
        )
        
        SafetyStrategyCard(
          number: 3,
          title: "Diverse Teams",
          description: "Having people from different backgrounds work on AI projects brings different perspectives and helps catch biases that others might miss.",
          color: .purple
        )
        
        SafetyStrategyCard(
          number: 4,
          title: "Transparency & Accountability",
          description: "Making it clear how AI systems make decisions and having humans review important choices, especially ones that affect people's lives.",
          color: .orange
        )
      }
    }
    .padding(.horizontal)
  }
}

struct SafetyStrategyCard: View {
  let number: Int
  let title: String
  let description: String
  let color: Color
  
  var body: some View {
    HStack(alignment: .top, spacing: 15) {
      VStack {
        ZStack {
          Circle()
            .fill(color)
            .frame(width: 50, height: 50)
          Text("\(number)")
            .font(.title2.bold())
            .foregroundStyle(.white)
        }
      }
      
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.headline)
        
        Text(description)
          .font(.body)
          .foregroundStyle(.secondary)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.08))
    .cornerRadius(12)
  }
}

struct AISafetyBias4: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 25) {
        Text("Why Should You Care About AI Bias?")
          .font(.title.bold())
        
        Text(
          "AI is becoming part of everyday life - from the apps on your phone to important decisions about loans, healthcare, and education. Understanding AI bias helps you be a more informed user and maybe even a future creator of better AI!"
        )
        
        VStack(spacing: 20) {
          ImpactCard(
            icon: "lightbulb.fill",
            color: .yellow,
            title: "Be a Critical Thinker",
            points: [
              "Question whether AI decisions seem fair",
              "Recognize that AI isn't always neutral or 'objective'",
              "Understand that AI reflects human choices and data"
            ]
          )
          
          ImpactCard(
            icon: "hand.raised.fill",
            color: .red,
            title: "Take Action",
            points: [
              "Report biased or unfair AI behavior when you see it",
              "Support companies and products that prioritize fairness",
              "Learn about AI ethics if you're interested in tech careers"
            ]
          )
          
          ImpactCard(
            icon: "arrow.forward.circle.fill",
            color: .blue,
            title: "Shape the Future",
            points: [
              "The next generation of AI builders could be YOU!",
              "Your perspective matters in making AI fair for everyone",
              "Understanding these issues now prepares you to create better technology"
            ]
          )
        }
        
        Text("Remember: AI is a tool created by humans. We have the power to make it better, fairer, and more helpful for everyone! 🌟")
          .font(.headline)
          .foregroundStyle(.purple)
          .multilineTextAlignment(.center)
          .padding(.top, 10)
      }
      .padding(.horizontal)
    }
  }
}

struct ImpactCard: View {
  let icon: String
  let color: Color
  let title: String
  let points: [String]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .font(.title)
          .foregroundStyle(color)
        
        Text(title)
          .font(.title3.bold())
      }
      
      VStack(alignment: .leading, spacing: 8) {
        ForEach(points.indices, id: \.self) { index in
          HStack(alignment: .top, spacing: 8) {
            Text("•")
              .font(.title3)
              .foregroundStyle(color)
            Text(points[index])
              .font(.body)
          }
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.1))
    .cornerRadius(12)
  }
}
