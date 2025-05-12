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

struct WordleView: View {
    // 6 rows × 5 letters (letter + state)
    @State private var grid: [[(letter: String, state: LetterState)]] =
        Array(repeating: Array(repeating: ("", .empty), count: 5), count: 6)
    
    // Keyboard coloring
    @State private var letterStates: [String: LetterState] = [:]
    
    // Which row & column we're typing into
    @State private var currentRow: Int = 0
    @State private var currentCol: Int = 0
    
    // The secret word for this round
    @State private var targetWord: String = { WordBank.randomWord() }()
    
    private let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("WORDLE")
                .font(.largeTitle).bold().padding(.top)
            
            // MARK: – Grid
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
            
            // MARK: – Keyboard
            VStack(spacing: 6) {
                ForEach(rows.prefix(2), id: \.self) { rowKeys in
                    HStack(spacing: 6) {
                        ForEach(Array(rowKeys), id: \.self) { ch in
                            KeyView(key: String(ch),
                                    state: letterStates[String(ch)] ?? .empty) {
                                handleKeyPress(ch)
                            }
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    KeyView(key: "ENTER", state: .empty) {
                        submitGuess()
                    }
                    ForEach(Array(rows.last!), id: \.self) { ch in
                        KeyView(key: String(ch),
                                state: letterStates[String(ch)] ?? .empty) {
                            handleKeyPress(ch)
                        }
                    }
                    KeyView(key: "⌫", state: .empty) {
                        deleteLetter()
                    }
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            print("🌟 Today's word is \(targetWord)")
        }
    }
    
    // MARK: – Fill in one letter at a time
    private func handleKeyPress(_ ch: Character) {
        guard currentRow < 6, currentCol < 5 else { return }
        // Put letter into grid; leave state as .empty
        grid[currentRow][currentCol].letter = String(ch)
        grid[currentRow][currentCol].state  = .empty
        currentCol += 1
    }
    
    // MARK: – Backspace
    private func deleteLetter() {
        guard currentRow < 6, currentCol > 0 else { return }
        currentCol -= 1
        grid[currentRow][currentCol].letter = ""
        grid[currentRow][currentCol].state  = .empty
    }
    
    // MARK: – (placeholder) evaluate the guess
    private func submitGuess() {
        // only when currentCol == 5:
        guard currentCol == 5 else { return }
        // here you’d compare grid[currentRow][0..<5].letter
        // against targetWord, update each cell.state, update letterStates,
        // then move to next row:
        //   currentRow += 1
        //   currentCol  = 0
    }
}

// MARK: – Preview

struct WordleView_Previews: PreviewProvider {
  static var previews: some View {
    WordleView()
  }
}
