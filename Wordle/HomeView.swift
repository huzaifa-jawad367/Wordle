//
//  HomeView.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 12/05/2025.
//

import SwiftUI

// MARK: – Model
enum LetterState {
    case empty, absent, present, correct

    var background: Color {
        switch self {
            case .empty:   return Color(.systemGray6)
            case .absent:  return Color(.systemGray)
            case .present: return Color.yellow
            case .correct: return Color.green
        }
    }
  
    var textColor: Color {
        self == .empty ? .primary : .white
    }
}

// MARK: – Tile View
struct TileView: View {
    let letter: String
    let state: LetterState

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(state.background)
            Text(letter)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(state.textColor)
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: – Keyboard Key View
struct KeyView: View {
    let key: String
    let state: LetterState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(key)
                .font(.system(size: 16, weight: .semibold))
                .frame(minWidth: 30, minHeight: 44)
                .background(RoundedRectangle(cornerRadius: 4).fill(state.background))
                .foregroundColor(state.textColor)
        }
    }
}

// MARK: – Main Wordle View
struct WordleView: View {
    // Your game state goes here:
    // 6 rows × 5 letters
    @State private var grid: [[(letter: String, state: LetterState)]] =
    Array(repeating: Array(repeating: ("", .empty), count: 5), count: 6)
    
    // Tracks each letter’s highest‐priority state for coloring the keyboard
    @State private var letterStates: [String: LetterState] = [:]
    
    // Keyboard rows
    private let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    var body: some View {
        VStack(spacing: 12) {
            // Title / spacing
            Text("WORDLE")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // 6×5 Grid
            VStack(spacing: 4) {
                ForEach(0..<6) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<5) { col in
                            let cell = grid[row][col]
                            TileView(letter: cell.letter, state: cell.state)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            Spacer()
            
            // MARK: – On-screen Keyboard
            VStack(spacing: 6) {
              // Top two rows unchanged
              ForEach(["QWERTYUIOP", "ASDFGHJKL"], id: \.self) { rowKeys in
                HStack(spacing: 6) {
                  ForEach(Array(rowKeys), id: \.self) { ch in
                    KeyView(key: String(ch),
                            state: letterStates[String(ch)] ?? .empty) {
                      handleKeyPress(ch)
                    }
                  }
                }
              }

              // Bottom row with ENTER ... letters ... BACKSPACE
              HStack(spacing: 6) {
                // ENTER
                KeyView(key: "ENTER", state: .empty) {
                  submitGuess()
                }
                // Middle letters
                ForEach(Array("ZXCVBNM"), id: \.self) { ch in
                  KeyView(key: String(ch),
                          state: letterStates[String(ch)] ?? .empty) {
                    handleKeyPress(ch)
                  }
                }
                // BACKSPACE
                KeyView(key: "⌫", state: .empty) {
                  deleteLetter()
                }
              }
            }
            .padding(.bottom)
        }
    }
    
    // MARK: – Game logic stubs
    
    private func handleKeyPress(_ ch: Character) {
        // e.g. append to current guess, then when you evaluate:
        // update grid[row][col].state and letterStates[String(ch)] to .present/.correct/.absent
    }
    
    private func submitGuess() {
      // check if current row has 5 letters,
      // evaluate and update grid states + letterStates
    }

    private func deleteLetter() {
      // remove last letter from current guess row
      // set that cell back to (“”, .empty)
    }
    
}

// MARK: – Preview

struct WordleView_Previews: PreviewProvider {
  static var previews: some View {
    WordleView()
  }
}
