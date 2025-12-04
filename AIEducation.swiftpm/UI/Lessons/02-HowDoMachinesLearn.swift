//
//  02-HowDoMachinesLearn.swift
//  AIEducation
//
//  Created by Ben Lawrence on 28/11/2025.
//

// MARK: - Status: WIP
import SwiftUI

struct Book: Identifiable {
  let id: UUID = UUID()
  let title: String
  let author: String
  let icon: String
  let color: Color
  
  static let books: [Book] = [
    Book(title: "To Kill a Mockingbird", author: "Harper Lee", icon: "bird", color: .blue),
    Book(title: "1984", author: "George Orwell", icon: "eye", color: .red),
    Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", icon: "star.fill", color: .yellow),
    Book(title: "Pride and Prejudice", author: "Jane Austen", icon: "heart.fill", color: .pink),
    Book(title: "The Catcher in the Rye", author: "J.D. Salinger", icon: "figure.walk", color: .orange),
    Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", icon: "crown.fill", color: .yellow),
    Book(title: "Animal Farm", author: "George Orwell", icon: "pawprint.fill", color: .brown),
    Book(title: "The Hobbit", author: "J.R.R. Tolkien", icon: "mountain.2.fill", color: .green),
    Book(title: "Fahrenheit 451", author: "Ray Bradbury", icon: "flame.fill", color: .orange),
    Book(title: "Brave New World", author: "Aldous Huxley", icon: "globe", color: .cyan),
    Book(title: "The Chronicles of Narnia", author: "C.S. Lewis", icon: "snow", color: .mint),
    Book(title: "Moby-Dick", author: "Herman Melville", icon: "water.waves", color: .blue),
    Book(title: "War and Peace", author: "Leo Tolstoy", icon: "flag.fill", color: .red),
    Book(title: "The Odyssey", author: "Homer", icon: "sailboat.fill", color: .teal),
    Book(title: "Frankenstein", author: "Mary Shelley", icon: "bolt.fill", color: .indigo),
    Book(title: "The Divine Comedy", author: "Dante Alighieri", icon: "sparkles", color: .yellow),
    Book(title: "Alice's Adventures in Wonderland", author: "Lewis Carroll", icon: "hare.fill", color: .purple),
    Book(title: "The Little Prince", author: "Antoine de Saint-Exupéry", icon: "moon.stars.fill", color: .yellow),
    Book(title: "Don Quixote", author: "Miguel de Cervantes", icon: "shield.fill", color: .brown)
  ]
}

struct BookView: View {
  let book: Book
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(book.color.gradient)
        .frame(width: 150, height: 225)
        .overlay(
          VStack {
            Image(systemName: book.icon)
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
              .foregroundStyle(.white)
            
            Spacer()
            
            Text(book.title)
              .font(.headline)
              .fontDesign(.rounded)
              .foregroundStyle(.white)
            Text(book.author)
              .font(.subheadline)
              .fontDesign(.rounded)
              .foregroundStyle(.white)
            
            Spacer()
          }
          .padding(.vertical)
        )
    }
  }
}

struct HowDoMachinesLearn1: View {
  @State private var imageCache: [String: UIImage] = [:]
  
  private var mixedContent: [FallingContent] {
    let books = Book.books.map { FallingContent.book($0) }
    let images = FallingImage.natureImageFilenames.map { FallingContent.image($0) }
    return books + images
  }
  
  enum FallingContent: Identifiable {
    case book(Book)
    case image(String)
    
    var id: String {
      switch self {
      case .book(let book):
        return "book-\(book.id)"
      case .image(let filename):
        return "image-\(filename)"
      }
    }
  }
  
  var body: some View {
    VStack {
      FallingItemsView(
        items: mixedContent,
        itemsToShow: 8,
        spawnInterval: 0.5,
        durationRange: 6...10
      ) { content in
        switch content {
        case .book(let book):
          BookView(book: book)
          
        case .image(let filename):
          if let uiImage = imageCache[filename] {
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
      }
      .overlay(
        VStack(spacing: 20) {
          Text("Machines Learn by Example")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
          
          Text("Just like humans, machines learn by being exposed to many examples. The more diverse and comprehensive the examples, the better the learning.")
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
          .padding()
          .glassEffect(.regular, in: .rect(cornerRadius: 15))
      )
    }
    .onAppear {
      preloadImages()
    }
  }
  
  func preloadImages() {
    DispatchQueue.global(qos: .userInitiated).async {
      let loadedImages = FallingImage.natureImageFilenames.compactMap { filename -> (String, UIImage)? in
        guard let path = Bundle.main.path(forResource: filename, ofType: nil),
              let image = UIImage(contentsOfFile: path) else {
          return nil
        }
        let size = CGSize(width: 80, height: 80)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let resizedImage = renderer.image { context in
          image.draw(in: CGRect(origin: .zero, size: size))
        }
        return (filename, resizedImage)
      }
      
      DispatchQueue.main.async {
        self.imageCache = Dictionary(uniqueKeysWithValues: loadedImages)
      }
    }
  }
}
