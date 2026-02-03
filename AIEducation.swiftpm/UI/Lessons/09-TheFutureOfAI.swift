//
//  09-WhereToUseAI.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

import SwiftUI

// MARK: - Status: Not Started
struct AIFutureCareers1: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("The Future is AI-Powered!")
        .font(.title.bold())
      
      Text(
        "AI is transforming the world faster than ever before. From healthcare to entertainment, education to transportation, AI is changing how we live, work, and play. The exciting part? This transformation is just beginning, and YOU could be part of shaping it!"
      )
      .font(.title3)
      
      Text(
        "Think about it: just 10 years ago, talking to AI assistants seemed like science fiction. Now, millions of people use them every day. In the next 10 years, AI will become even more integrated into our lives in ways we can't even imagine yet."
      )
      .foregroundStyle(.secondary)
      
      HStack(spacing: 30) {
        TimelineCard(
          time: "Past",
          icon: "clock.arrow.circlepath",
          color: .gray,
          description: "Basic calculators and simple automation"
        )
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .foregroundStyle(.blue)
        
        TimelineCard(
          time: "Today",
          icon: "sparkles",
          color: .blue,
          description: "AI assistants, image generation, smart recommendations"
        )
        
        Image(systemName: "arrow.right")
          .font(.largeTitle)
          .foregroundStyle(.purple)
        
        TimelineCard(
          time: "Future",
          icon: "wand.and.stars",
          color: .purple,
          description: "AI collaborators, personalized learning, creative partners"
        )
      }
      .padding(.top, 20)
    }
    .padding(.horizontal)
  }
}

struct TimelineCard: View {
  let time: String
  let icon: String
  let color: Color
  let description: String
  
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.system(size: 50))
        .foregroundStyle(color.gradient)
      
      Text(time)
        .font(.headline)
        .foregroundStyle(color.gradient)
      
      Text(description)
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .frame(height: 60)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(color.opacity(0.1).gradient)
    .cornerRadius(12)
  }
}

struct AIFutureCareers2: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("How Will AI Change Different Industries?")
        .font(.title.bold())
      
      Text(
        "AI isn't just one thing - it's transforming every field you can imagine! Here's a glimpse at how AI is shaping different industries:"
      )
      .foregroundStyle(.secondary)
      
      ScrollView {
        VStack(spacing: 15) {
          IndustryCard(
            icon: "heart.text.square.fill",
            color: .red,
            industry: "Healthcare",
            changes: [
              "AI helps doctors detect diseases earlier and more accurately",
              "Personalized treatment plans based on your unique health data",
              "Drug discovery happening faster than ever before"
            ]
          )
          
          IndustryCard(
            icon: "graduationcap.fill",
            color: .blue,
            industry: "Education",
            changes: [
              "Personalized learning that adapts to your pace and style",
              "AI tutors available 24/7 to help with homework",
              "Virtual reality classrooms that make learning immersive"
            ]
          )
          
          IndustryCard(
            icon: "paintbrush.fill",
            color: .purple,
            industry: "Creative Arts",
            changes: [
              "AI tools that help artists bring their visions to life faster",
              "Music composition assistants for songwriters",
              "AI-powered video editing and special effects"
            ]
          )
          
          IndustryCard(
            icon: "car.fill",
            color: .green,
            industry: "Transportation",
            changes: [
              "Self-driving cars making roads safer",
              "AI optimizing traffic flow in cities",
              "Smart delivery systems that predict what you need"
            ]
          )
          
          IndustryCard(
            icon: "leaf.fill",
            color: .mint,
            industry: "Environment",
            changes: [
              "AI monitoring climate change and predicting weather patterns",
              "Smart energy grids that reduce waste",
              "AI helping discover sustainable materials"
            ]
          )
        }
      }
    }
    .padding(.horizontal)
  }
}

struct IndustryCard: View {
  let icon: String
  let color: Color
  let industry: String
  let changes: [String]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .font(.title)
          .foregroundStyle(color.gradient)
        
        Text(industry)
          .font(.title3.bold())
      }
      
      VStack(alignment: .leading, spacing: 8) {
        ForEach(changes.indices, id: \.self) { index in
          HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
              .foregroundStyle(color.gradient)
              .font(.caption)
            Text(changes[index])
              .font(.body)
          }
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.08).gradient)
    .cornerRadius(12)
  }
}

struct AIFutureCareers3: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Exciting AI Career Paths")
        .font(.title.bold())
      
      Text(
        "The AI revolution is creating tons of new career opportunities - and many don't even exist yet! Here are some paths you could explore:"
      )
      .foregroundStyle(.secondary)
      
      ScrollView {
        VStack(spacing: 15) {
          CareerCard(
            icon: "brain.head.profile",
            color: .blue,
            title: "AI/ML Engineer",
            description: "Build and train AI models that can learn and make predictions",
            skills: ["Programming", "Math", "Problem-solving"],
            funFact: "This is one of the fastest-growing jobs in tech!"
          )
          
          CareerCard(
            icon: "chart.bar.doc.horizontal",
            color: .green,
            title: "Data Scientist",
            description: "Analyze huge amounts of data to find patterns and insights",
            skills: ["Statistics", "Critical thinking", "Communication"],
            funFact: "Every industry needs data scientists!"
          )
          
          CareerCard(
            icon: "text.bubble.fill",
            color: .purple,
            title: "AI Ethics Specialist",
            description: "Make sure AI systems are fair, safe, and beneficial for everyone",
            skills: ["Ethics", "Communication", "Understanding bias"],
            funFact: "You can help shape how AI affects society!"
          )
          
          CareerCard(
            icon: "paintpalette.fill",
            color: .orange,
            title: "AI-Assisted Creator",
            description: "Use AI tools to create art, music, videos, games, and more",
            skills: ["Creativity", "Design", "Storytelling"],
            funFact: "AI is a tool that amplifies human creativity!"
          )
          
          CareerCard(
            icon: "stethoscope",
            color: .red,
            title: "AI Healthcare Specialist",
            description: "Apply AI to improve medical diagnosis, treatment, and patient care",
            skills: ["Medical knowledge", "Technology", "Empathy"],
            funFact: "AI could help doctors save millions of lives!"
          )
          
          CareerCard(
            icon: "lightbulb.fill",
            color: .yellow,
            title: "AI Product Manager",
            description: "Design AI products and features that people love to use",
            skills: ["User research", "Communication", "Strategy"],
            funFact: "You decide WHAT to build, not just HOW!"
          )
        }
      }
    }
    .padding(.horizontal)
  }
}

struct CareerCard: View {
  let icon: String
  let color: Color
  let title: String
  let description: String
  let skills: [String]
  let funFact: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .font(.system(size: 40))
          .foregroundStyle(color.gradient)
          .frame(width: 60)
        
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
          
          Text(description)
            .font(.body)
            .foregroundStyle(.secondary)
        }
      }
      
      Divider()
      
      VStack(alignment: .leading, spacing: 8) {
        Text("Key Skills:")
          .font(.caption.bold())
          .foregroundStyle(.secondary)
        
        HStack {
          ForEach(skills, id: \.self) { skill in
            Text(skill)
              .font(.caption)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(color.opacity(0.2))
              .cornerRadius(8)
          }
        }
      }
      
      HStack(spacing: 6) {
        Image(systemName: "star.fill")
          .foregroundStyle(color.gradient)
          .font(.caption)
        Text(funFact)
          .font(.caption)
          .italic()
          .foregroundStyle(.secondary)
      }
    }
    .padding()
    .background(color.opacity(0.08).gradient)
    .cornerRadius(12)
  }
}

struct AIFutureCareers4: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 25) {
        Text("How Can YOU Prepare for an AI Future?")
          .font(.title.bold())
        
        Text(
          "Good news: you don't need to be a math genius or coding expert to work with AI! Here's how you can start preparing today, no matter what you're interested in:"
        )
        
        VStack(spacing: 20) {
          PreparationCard(
            icon: "book.fill",
            color: .blue,
            title: "Stay Curious & Keep Learning",
            tips: [
              "Explore how AI tools work - try them out!",
              "Learn the basics of how AI thinks (like you're doing now! 🎉)",
              "Follow AI news and developments"
            ]
          )
          
          PreparationCard(
            icon: "hammer.fill",
            color: .orange,
            title: "Build Things",
            tips: [
              "Create projects using AI tools (art, writing, code)",
              "Try coding - even simple projects help you understand AI",
              "Don't be afraid to experiment and make mistakes!"
            ]
          )
          
          PreparationCard(
            icon: "person.3.fill",
            color: .green,
            title: "Develop Human Skills",
            tips: [
              "Critical thinking - question what AI tells you",
              "Creativity - AI needs human imagination!",
              "Communication - explaining ideas matters more than ever"
            ]
          )
          
          PreparationCard(
            icon: "star",
            color: .purple,
            title: "Find Your Passion",
            tips: [
              "You don't have to work IN AI - you can use AI in ANY field!",
              "Love art? Sports? Medicine? Gaming? AI will be there!",
              "The best AI careers combine tech with what YOU love"
            ]
          )
        }
        
        VStack(spacing: 8) {
          Text("Remember:")
            .font(.headline)
          
          Text("The future of AI isn't just being built by scientists in labs - it's being shaped by people from all backgrounds with diverse interests and ideas. That includes YOU! 🚀")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(.blue)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
      }
    }
    .padding(.horizontal)
  }
}

struct PreparationCard: View {
  let icon: String
  let color: Color
  let title: String
  let tips: [String]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .font(.title2)
          .foregroundStyle(color.gradient)
        
        Text(title)
          .font(.headline)
      }
      
      VStack(alignment: .leading, spacing: 6) {
        ForEach(tips.indices, id: \.self) { index in
          HStack(alignment: .top, spacing: 8) {
            Text("•")
              .font(.body.bold())
              .foregroundStyle(color.gradient)
            Text(tips[index])
              .font(.body)
          }
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.08).gradient)
    .cornerRadius(12)
  }
}
