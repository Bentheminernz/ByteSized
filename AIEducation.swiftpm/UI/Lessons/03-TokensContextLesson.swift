//
//  03-TokensContextLesson.swift
//  AIEducation
//
//  Created by Ben Lawrence on 17/11/2025.
//

// MARK: - Status: Completed
import SwiftUI

// MARK: - Slide 1: Introduction to Tokens
struct TokenContextLesson1: View {
  @State private var tokenizer: Tokenizer = Tokenizer()
  @State private var inputText: String = ""
  @State private var tokens: [Token] = []
  @State private var viewState: ViewState = .text
  @State private var visibleDemoText: String = ""
  @State private var timer: Timer?

  enum ViewState { case text, token }

  var fullDemoText = "The quick brown fox jumps over the lazy dog."

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text("What Are Tokens?")
          .font(.title.bold())
        
        Text(
          "AI doesn't read text the same way you do! Instead, it breaks everything down into smaller pieces called **tokens**. Think of tokens like puzzle pieces that make up words and sentences."
        )
        .font(.body)
        .foregroundStyle(.secondary)

        VStack(alignment: .leading, spacing: 12) {
          Text("Example: Breaking Down a Sentence")
            .font(.headline)
          
          Text("Let's see how AI breaks down this sentence:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
          
          Text("\"\(fullDemoText)\"")
            .font(.body)
            .italic()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.1))
            )
          
          Text("Into tokens:")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          WrapLayout(spacing: 6) {
            ForEach(tokenizer.tokenize(visibleDemoText).indices, id: \.self) {
              index in
              switch viewState {
              case .text:
                TokenChip(
                  text: tokenizer.tokenize(visibleDemoText)[index].text,
                  color: TokenChip.color(for: index)
                )
              case .token:
                TokenChip(
                  text: String(
                    tokenizer.tokenize(visibleDemoText)[index].tokenID
                  ),
                  color: .clear,
                  border: .secondary
                )
              }
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.gray.opacity(0.05))
          )
        }

        VStack(alignment: .leading, spacing: 12) {
          Text("Try It Yourself!")
            .font(.headline)
          
          TextField("Type something to see it broken into tokens...", text: $inputText)
            .padding()
            .glassEffect(.regular.interactive(), in: .capsule)

          HStack {
            Text("Token Count:")
              .foregroundStyle(.secondary)
            Text("\(tokens.count)")
              .contentTransition(.numericText(value: Double(tokens.count)))
              .bold()
              .foregroundStyle(.blue)
            
            Spacer()
            
            Picker("View Mode", selection: $viewState) {
              Text("Text").tag(ViewState.text)
              Text("IDs").tag(ViewState.token)
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
          }

          if !tokens.isEmpty {
            WrapLayout(spacing: 6) {
              ForEach(tokens.indices, id: \.self) { index in
                switch viewState {
                case .text:
                  TokenChip(
                    text: tokens[index].text,
                    color: TokenChip.color(for: index)
                  )
                case .token:
                  TokenChip(
                    text: String(tokens[index].tokenID),
                    color: .clear,
                    border: .secondary
                  )
                }
              }
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.05))
            )
          }
        }

        Text("**Fun Fact:** Each colored chip is a token! AI assigns each token a unique number (ID) to process it.")
          .font(.caption)
          .foregroundStyle(.secondary)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.yellow.opacity(0.1))
          )
      }
      .padding()
    }
    .onChange(of: inputText) {
      withAnimation(.bouncy) {
        tokens = tokenizer.tokenize(inputText)
      }
    }
    .onAppear {
      startTextAnimation()
    }
    .animation(.bouncy, value: viewState)
  }

  private func startTextAnimation() {
    visibleDemoText = ""
    let totalDuration: TimeInterval = 4.0
    let characterCount = fullDemoText.count
    let intervalTime = totalDuration / Double(characterCount)
    var currentIndex = 0

    Task {
      while currentIndex < fullDemoText.count {
        try? await Task.sleep(nanoseconds: UInt64(intervalTime * 1_000_000_000))
        let index = fullDemoText.index(
          fullDemoText.startIndex,
          offsetBy: currentIndex
        )
        withAnimation(.bouncy) {
          visibleDemoText.append(fullDemoText[index])
        }
        currentIndex += 1
      }
    }
  }
}

// MARK: - Slide 2: Why Tokens Matter
struct TokenContextLesson2: View {
  @State private var selectedExample = 0
  
  let examples = [
    (word: "cat", tokens: ["cat"], count: 1, description: "Simple words = 1 token"),
    (word: "jumping", tokens: ["jump", "ing"], count: 2, description: "Complex words may split"),
    (word: "AI", tokens: ["AI"], count: 1, description: "Acronyms are usually 1 token"),
    (word: "🎉🎊", tokens: ["🎉", "🎊"], count: 2, description: "Emojis = 1 token each"),
  ]
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Why Do Tokens Matter?")
        .font(.title.bold())
      
      Text(
        "Understanding tokens helps you know how AI 'sees' your text. Different words can use different amounts of tokens!"
      )
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      
      HStack {
        ForEach(examples, id: \.word) { example in
          Circle()
            .fill(TokenChip.color(for: examples.firstIndex(where: { $0.word == example.word }) ?? 0).opacity(selectedExample == examples.firstIndex(where: { $0.word == example.word }) ? 1 : 0.1))
            .frame(width: 20, height: 20)
            .overlay(
              Circle()
                .stroke(TokenChip.color(for: examples.firstIndex(where: { $0.word == example.word }) ?? 0), lineWidth: 2)
            )
            .onTapGesture {
              if let index = examples.firstIndex(where: { $0.word == example.word }) {
                withAnimation(.easeInOut) {
                  selectedExample = index
                }
              }
            }
        }
      }
      
      TabView(selection: $selectedExample) {
        ForEach(examples.indices, id: \.self) { index in
          VStack(spacing: 25) {
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color.purple.opacity(0.1))
                .frame(height: 300)
              
              VStack(spacing: 20) {
                Text(examples[index].word)
                  .font(.system(size: 60))
                  .bold()
                
                Image(systemName: "arrow.down")
                  .font(.title)
                  .foregroundStyle(.purple)
                
                HStack(spacing: 10) {
                  ForEach(examples[index].tokens.indices, id: \.self) { tokenIndex in
                    Text(examples[index].tokens[tokenIndex])
                      .font(.title3)
                      .padding()
                      .background(
                        RoundedRectangle(cornerRadius: 10)
                          .fill(TokenChip.color(for: tokenIndex).opacity(0.3))
                      )
                      .overlay(
                        RoundedRectangle(cornerRadius: 10)
                          .stroke(TokenChip.color(for: tokenIndex), lineWidth: 2)
                      )
                  }
                }
                
                VStack(spacing: 8) {
                  HStack {
                    Image(systemName: "number.circle.fill")
                      .foregroundStyle(.purple)
                    Text("Token Count:")
                      .foregroundStyle(.secondary)
                    Text("\(examples[index].count)")
                      .bold()
                      .foregroundStyle(.purple)
                  }
                  
                  Text(examples[index].description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
                }
              }
            }
          }
          .tag(index)
          .padding()
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .frame(height: 300)
      .animation(.easeInOut	, value: selectedExample)
      
      Text("**Why it matters:** AI models have limits on how many tokens they can process at once. Knowing this helps you write better prompts!")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.yellow.opacity(0.1))
        )
    }
    .padding()
  }
}

// MARK: - Slide 3: Context Windows
struct TokenContextLesson3: View {
  @State private var showAnimation = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("What is a Context Window?")
          .font(.title.bold())
        
        Text(
          "AI doesn't remember everything forever. It can only 'see' a limited amount of text at once, called the **Context Window**."
        )
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue.opacity(0.05))
            .frame(height: 400)
          
          VStack(spacing: 30) {
            Text("Think of it like...")
              .font(.headline)
              .foregroundStyle(.secondary)
            
            HStack(spacing: 40) {
              VStack(spacing: 15) {
                Image(systemName: "book.pages")
                  .font(.system(size: 50))
                  .foregroundStyle(.blue)
                
                Text("Reading a Book")
                  .font(.headline)
                
                Text("You can only see the current pages")
                  .font(.caption)
                  .foregroundStyle(.secondary)
                  .multilineTextAlignment(.center)
              }
              .frame(width: 150)
              
              Image(systemName: "arrow.left.and.right")
                .foregroundStyle(.gray)
              
              VStack(spacing: 15) {
                Image(systemName: "brain.head.profile")
                  .font(.system(size: 50))
                  .foregroundStyle(.purple)
                
                Text("AI's Memory")
                  .font(.headline)
                
                Text("Can only see text in its context window")
                  .font(.caption)
                  .foregroundStyle(.secondary)
                  .multilineTextAlignment(.center)
              }
              .frame(width: 150)
            }
            
            Divider()
              .padding(.horizontal)
            
            ContextWindowDiagram(showAnimation: showAnimation)
          }
          .padding()
        }
        
        VStack(alignment: .leading, spacing: 15) {
          Text("What's Inside the Context Window?")
            .font(.headline)
          
          VStack(spacing: 10) {
            ContextItem(
              icon: "person.bubble",
              title: "Your Messages",
              description: "Everything you've typed in the conversation",
              color: .blue
            )
            
            ContextItem(
              icon: "bubble.left.and.bubble.right",
              title: "AI's Responses",
              description: "All previous replies from the AI",
              color: .purple
            )
            
            ContextItem(
              icon: "doc.text",
              title: "System Instructions",
              description: "Hidden instructions that guide the AI's behavior",
              color: .orange
            )
          }
        }
        
        Text("⚠️ **Important:** When the context window fills up, the AI starts 'forgetting' older messages!")
          .font(.caption)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.orange.opacity(0.1))
          )
      }
      .padding()
    }
    .onAppear {
      withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
        showAnimation = true
      }
    }
  }
}

struct ContextItem: View {
  let icon: String
  let title: String
  let description: String
  let color: Color
  
  var body: some View {
    HStack(spacing: 15) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(color)
        .frame(width: 40)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(color.opacity(0.1))
    )
  }
}

struct ContextWindowDiagram: View {
  let showAnimation: Bool
  let outerDiameter: CGFloat = 200
  let innerDiameter: CGFloat = 70
  
  var body: some View {
    ZStack {
      // Outer circle - Context Window
      Circle()
        .strokeBorder(Color.blue.opacity(0.5), lineWidth: 3)
        .frame(width: outerDiameter, height: outerDiameter)
        .overlay(
          Circle()
            .fill(Color.blue.opacity(0.05))
        )
        .overlay(
          Text("Context Window")
            .font(.caption.bold())
            .foregroundStyle(.blue)
            .offset(y: -outerDiameter * 0.55)
        )
      
      // Inner circles representing content
      innerCircle("Your\nMessages", color: .blue)
        .offset(y: -outerDiameter * 0.28)
        .scaleEffect(showAnimation ? 1.05 : 1.0)
      
      innerCircle("AI\nReplies", color: .purple)
        .offset(x: -outerDiameter * 0.24, y: outerDiameter * 0.15)
        .scaleEffect(showAnimation ? 1.05 : 1.0)
      
      innerCircle("System\nRules", color: .orange)
        .offset(x: outerDiameter * 0.24, y: outerDiameter * 0.15)
        .scaleEffect(showAnimation ? 1.05 : 1.0)
    }
    .frame(width: outerDiameter, height: outerDiameter)
  }
  
  @ViewBuilder
  private func innerCircle(_ text: String, color: Color) -> some View {
    Circle()
      .fill(color.opacity(0.2))
      .overlay(
        Circle()
          .strokeBorder(color, lineWidth: 2)
      )
      .frame(width: innerDiameter, height: innerDiameter)
      .overlay(
        Text(text)
          .font(.caption2.bold())
          .multilineTextAlignment(.center)
          .foregroundStyle(color)
      )
  }
}

// MARK: - Slide 4: Context Window Limits
struct TokenContextLesson4: View {
  @State private var selectedModel: Int = 0
  @State private var fillPercentage: Double = 0
  
  let models = [
    (name: "Small Model", limit: "4,000 tokens", pages: "~8 pages", color: Color.red),
    (name: "Medium Model", limit: "16,000 tokens", pages: "~32 pages", color: Color.orange),
    (name: "Large Model", limit: "128,000 tokens", pages: "~256 pages", color: Color.green),
  ]
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Context Window Sizes")
          .font(.title.bold())
        
        Text(
          "Different AI models have different context window sizes. Larger windows can remember more of your conversation!"
        )
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        
        Picker("Model", selection: $selectedModel) {
          ForEach(models.indices, id: \.self) { index in
            Text(models[index].name).tag(index)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .fill(models[selectedModel].color.opacity(0.1))
            .frame(height: 350)
          
          VStack(spacing: 25) {
            Image(systemName: "brain.head.profile")
              .font(.system(size: 60))
              .foregroundStyle(models[selectedModel].color)
            
            VStack(spacing: 10) {
              Text(models[selectedModel].name)
                .font(.title2.bold())
              
              HStack(spacing: 20) {
                VStack {
                  Text(models[selectedModel].limit)
                    .font(.headline)
                    .foregroundStyle(models[selectedModel].color)
                  Text("Max Tokens")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                Divider()
                  .frame(height: 40)
                
                VStack {
                  Text(models[selectedModel].pages)
                    .font(.headline)
                    .foregroundStyle(models[selectedModel].color)
                  Text("≈ of Text")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
              }
            }
            
            VStack(spacing: 10) {
              Text("Memory Capacity")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
              
              GeometryReader { geometry in
                ZStack(alignment: .leading) {
                  RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 30)
                  
                  RoundedRectangle(cornerRadius: 10)
                    .fill(models[selectedModel].color)
                    .frame(
                      width: geometry.size.width * fillPercentage,
                      height: 30
                    )
                }
              }
              .frame(height: 30)
              .padding(.horizontal)
            }
          }
          .padding()
        }
        
        VStack(alignment: .leading, spacing: 10) {
          ComparisonRow(
            icon: "checkmark.circle.fill",
            text: "Larger windows = More context",
            color: .green
          )
          ComparisonRow(
            icon: "checkmark.circle.fill",
            text: "Can handle longer conversations",
            color: .green
          )
          ComparisonRow(
            icon: "info.circle.fill",
            text: "Larger windows may cost more",
            color: .blue
          )
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.05))
        )
      }
    }
    .padding(.horizontal)
    .onChange(of: selectedModel) { _, _ in
      withAnimation(.bouncy) {
        fillPercentage = Double(selectedModel + 1) / Double(models.count)
      }
    }
    .onAppear {
      withAnimation(.bouncy) {
        fillPercentage = Double(selectedModel + 1) / Double(models.count)
      }
    }
  }
}

struct ComparisonRow: View {
  let icon: String
  let text: String
  let color: Color
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundStyle(color)
      Text(text)
        .font(.body)
      Spacer()
    }
  }
}

// MARK: - Slide 5: Practical Tips
struct TokenContextLesson5: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Working with Tokens & Context")
          .font(.title.bold())
        
        Text(
          "Now you know about tokens and context windows! Here are some practical tips for working with AI."
        )
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        
        VStack(spacing: 15) {
          TipCard(
            icon: "text.alignleft",
            title: "Be Concise",
            description: "Use clear, direct language to save tokens and get better responses.",
            color: .blue
          )
          
          TipCard(
            icon: "list.bullet.clipboard",
            title: "Stay Organized",
            description: "Break complex requests into smaller parts if you're running out of context.",
            color: .green
          )
          
          TipCard(
            icon: "arrow.clockwise",
            title: "Start Fresh When Needed",
            description: "If the conversation gets too long, start a new chat to clear the context.",
            color: .orange
          )
          
          TipCard(
            icon: "lightbulb.max",
            title: "Important Info First",
            description: "Put crucial information at the start of your prompt - it's less likely to be forgotten.",
            color: .purple
          )
        }
        
        VStack(spacing: 15) {
          Text("Quick Comparison")
            .font(.headline)
          
          HStack(spacing: 20) {
            ComparisonCard(
              title: "Less Effective",
              icon: "x.circle.fill",
              items: [
                "Very long, rambling messages",
                "Repeating the same info",
                "Continuing after hitting limits"
              ],
              color: .red
            )
            
            ComparisonCard(
              title: "More Effective",
              icon: "checkmark.circle.fill",
              items: [
                "Clear, focused messages",
                "Getting to the point",
                "Starting fresh when needed"
              ],
              color: .green
            )
          }
        }
        
        Text("**You've learned:** How AI breaks text into tokens and why context windows matter for conversations!")
          .font(.caption)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.blue.opacity(0.1))
          )
      }
      .padding(.horizontal)
    }
  }
}

struct TipCard: View {
  let icon: String
  let title: String
  let description: String
  let color: Color
  
  var body: some View {
    HStack(alignment: .top, spacing: 6) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(color)
        .frame(width: 40)
      
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.body)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(color.opacity(0.1))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(color.opacity(0.3), lineWidth: 1)
    )
  }
}

struct ComparisonCard: View {
  let title: String
  let icon: String
  let items: [String]
  let color: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label(title, systemImage: icon)
        .font(.headline)
        .foregroundStyle(color)
      
      ForEach(items, id: \.self) { item in
        HStack(alignment: .center, spacing: 8) {
          Text("•")
            .foregroundStyle(color)
          Text(item)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(color.opacity(0.1))
    )
  }
}

// MARK: - Supporting Components
struct WrapLayout: Layout {
  var spacing: CGFloat = 6

  struct Cache {}

  func makeCache(subviews: Subviews) -> Cache { Cache() }

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> CGSize {
    let maxWidth = proposal.width ?? .infinity
    var x: CGFloat = 0
    var y: CGFloat = 0
    var lineHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(ProposedViewSize.unspecified)
      if x + size.width > maxWidth {
        x = 0
        y += lineHeight + spacing
        lineHeight = 0
      }
      lineHeight = max(lineHeight, size.height)
      x += size.width + spacing
    }

    return CGSize(
      width: maxWidth == .infinity ? x : maxWidth,
      height: y + lineHeight
    )
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) {
    let maxWidth = bounds.width
    var x: CGFloat = 0
    var y: CGFloat = 0
    var lineHeight: CGFloat = 0

    for view in subviews {
      let size = view.sizeThatFits(ProposedViewSize.unspecified)
      if x + size.width > maxWidth {
        x = 0
        y += lineHeight + spacing
        lineHeight = 0
      }
      view.place(
        at: CGPoint(
          x: bounds.minX + x,
          y: bounds.minY + y
        ),
        proposal: ProposedViewSize(
          width: size.width,
          height: size.height
        )
      )
      lineHeight = max(lineHeight, size.height)
      x += size.width + spacing
    }
  }
}

struct TokenChip: View {
  let text: String
  var color: Color
  var border: Color? = nil

  var body: some View {
    Text(text)
      .font(.body)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(color.opacity(color == .clear ? 0 : 0.25))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(border ?? .clear, lineWidth: border == nil ? 0 : 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
  }

  static func color(for index: Int) -> Color {
    let palette: [Color] = [
      .blue, .green, .orange, .pink, .purple, .teal, .indigo, .red, .mint,
      .brown,
    ]
    return palette[index % palette.count]
  }
}
