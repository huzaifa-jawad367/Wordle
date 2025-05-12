//
//  WordBank.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 12/05/2025.
//


import Foundation

/// A simple word‐list provider for Wordle
struct WordBank {
  /// Your full list of valid 5-letter words
  static let allWords: [String] = [
    "APPLE","BRAVE","CARVE","DELTA","EPOCH",
    // … add the rest of your word list here …
  ]

  /// Returns a random word from the bank
  static func randomWord() -> String {
    allWords.randomElement()!
  }
}
