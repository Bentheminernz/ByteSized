//
//  Tokenizer.swift
//  AIEducation
//
//  Created by Ben Lawrence on 17/11/2025.
//

import Foundation

struct Token {
  let text: String
  let tokenID: Int
}

/// A simple tokenizer that mimics GPT-style tokenization with caching and basic BPE-like merging.
class Tokenizer {
  private var tokenCache: [String: Int] = [:]
  private var nextID = 0
  
  // get or create token id, then store to cache
  private func getTokenID(for text: String) -> Int {
    if let cachedID = tokenCache[text] {
      return cachedID
    }
    
    let id = hashToID(text)
    tokenCache[text] = id
    return id
  }
  
  // hash -> id, pretty simple stuff
  private func hashToID(_ text: String) -> Int {
    var hash = 5381
    for char in text.utf8 {
      hash = ((hash << 5) &+ hash) &+ Int(char)
    }
    return abs(hash % 50000) // 50k max tokens
  }
  
  private func isAlphanumeric(_ char: Character) -> Bool {
    return char.isLetter || char.isNumber
  }
  
  private func isWhitespace(_ char: Character) -> Bool {
    return char.isWhitespace
  }
  
  private func isPunctuation(_ char: Character) -> Bool {
    let punctuationSet = CharacterSet.punctuationCharacters
    return char.unicodeScalars.allSatisfy { punctuationSet.contains($0) }
  }
  
  // splits the text into chunks based on character types
  private func splitIntoChunks(_ text: String) -> [String] {
    var chunks: [String] = []
    var currentChunk = ""
    var lastType: String = ""
    
    for char in text {
      var currentType: String
      
      if isWhitespace(char) {
        currentType = "whitespace"
      } else if isAlphanumeric(char) {
        currentType = "alphanumeric"
      } else if isPunctuation(char) {
        currentType = "punctuation"
      } else {
        currentType = "other"
      }
      
      if currentType != lastType && !currentChunk.isEmpty {
        chunks.append(currentChunk)
        currentChunk = ""
      }
      
      currentChunk.append(char)
      lastType = currentType
    }
    
    if !currentChunk.isEmpty {
      chunks.append(currentChunk)
    }
    
    return chunks
  }
  
  // apply byte pair encoding style merging
  private func applyBPEMerging(_ chunks: [String]) -> [String] {
    var tokens = chunks
    
    tokens = mergeCommonPatterns(tokens)
    
    return tokens
  }
  
  // merge common pattenrs like suffixes and spaces
  private func mergeCommonPatterns(_ tokens: [String]) -> [String] {
    var merged: [String] = []
    var i = 0
    
    while i < tokens.count {
      // if it makes sense, merge with next token
      if i + 1 < tokens.count {
        let current = tokens[i]
        let next = tokens[i + 1]
        
        // merge whitespace + alphanumeric
        if isWhitespace(current.first ?? " ") && isAlphanumeric(next.first ?? "a") {
          merged.append(current + next)
          i += 2
          continue
        }
        
        // merge alphanumeric + suffix
        if shouldMergeSuffix(current, next) {
          merged.append(current + next)
          i += 2
          continue
        }
      }
      
      merged.append(tokens[i])
      i += 1
    }
    
    return merged
  }
  
  // should we merge this suffix?
  private func shouldMergeSuffix(_ base: String, _ suffix: String) -> Bool {
    let commonSuffixes = ["ing", "ed", "er", "ly", "tion", "ness", "ment", "s"]
    return commonSuffixes.contains(suffix.lowercased()) &&
    isAlphanumeric(base.first ?? " ")
  }
  
  /// Tokenize the input text into tokens with IDs.
  /// - Parameter text: The input text to tokenize.
  /// - Returns: An array of Token objects.
  func tokenize(_ text: String) -> [Token] {
    // step 1: split into chunks!
    let chunks = splitIntoChunks(text)
    
    // step 2: BPE merging
    let mergedTokens = applyBPEMerging(chunks)
    
    // step 3: create token objects
    let tokens = mergedTokens.map { tokenText in
      Token(text: tokenText, tokenID: getTokenID(for: tokenText))
    }
    
    // step 4: party!
    return tokens
  }
}
