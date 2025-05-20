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
    
    private static let validWords: Set<String> = {
        // 1. Debug start
        print("🔍 Loading valid_words.txt…")
        
        // 2. Try to find it in the main bundle (no subdirectory)
        guard let url = Bundle.main.url(
            forResource: "valid_words",
            withExtension: "txt"
        ) else {
            print("❌ valid_words.txt not found in bundle")
            return []
        }
        print("✅ Found valid_words.txt at \(url.path)")
        
        // 3. Read its contents
        let content: String
        do {
            content = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("❌ Failed to read valid_words.txt:", error)
            return []
        }
        
        // 4. Split & uppercase lines
        let lines = content
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
            .filter { !$0.isEmpty }
        
        print("🎉 Loaded \(lines.count) valid words")
        return Set(lines)
    }()

    
    @State private var showResult = false
    @State private var didWin = false
    
    @State private var grid: [[(letter: String, state: LetterState)]] =
        Array(repeating: Array(repeating: ("", .empty), count: 5), count: 6)
    @State private var letterStates: [String: LetterState] = [:]
    @State private var currentRow: Int = 0
    @State private var currentCol: Int = 0
    @State private var targetWord: String = { WordBank.randomWord().uppercased() }()

    private let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    @State private var showInvalidAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("WORDLE")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Grid
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

                // Keyboard
                VStack(spacing: 6) {
                    ForEach(rows.prefix(2), id: \.self) { rowKeys in
                        HStack(spacing: 6) {
                            ForEach(Array(rowKeys), id: \.self) { ch in
                                KeyView(
                                    key: String(ch),
                                    state: letterStates[String(ch)] ?? .empty
                                ) {
                                    handleKeyPress(ch)
                                }
                            }
                        }
                    }
                    HStack(spacing: 6) {
                        KeyView(key: "ENTER", state: currentCol < 5 ? .absent : .empty) {
                            submitGuess()
                        }
                        .opacity(currentCol < 5 ? 0.5 : 1.0)
                        .disabled(currentCol < 5)

                        ForEach(Array(rows.last!), id: \.self) { ch in
                            KeyView(
                                key: String(ch),
                                state: letterStates[String(ch)] ?? .empty
                            ) {
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
            .navigationBarHidden(true)
            .onAppear { print("🌟 Today's word is \(targetWord)") }
            .alert("Not in word list",
                   isPresented: $showInvalidAlert,
                   actions: {
                     Button("OK", role: .cancel) { }
                   },
                   message: {
                     Text("Please enter a valid five-letter word.")
                   })
            .navigationDestination(isPresented: $showResult) {
                ResultView(success: didWin, word: targetWord) {
                    resetGame()
                }
            }
        }
    }


    private func handleKeyPress(_ ch: Character) {
        guard currentRow < 6, currentCol < 5 else { return }
        grid[currentRow][currentCol].letter = String(ch)
        grid[currentRow][currentCol].state = .empty
        currentCol += 1
    }

    private func deleteLetter() {
        guard currentRow < 6, currentCol > 0 else { return }
        currentCol -= 1
        grid[currentRow][currentCol].letter = ""
        grid[currentRow][currentCol].state = .empty
    }

    private func submitGuess() {
        guard currentCol == 5 else { return }
//        let guess = grid[currentRow].map { $0.letter }.joined()
//        
//        guard Self.validWords.contains(guess.lowercased()) else {
//            print("Valid words: \(Self.validWords.joined(separator: ","))")
//            print("Not a valid word: \(guess)")
//            // Word not in list: you can show an alert or shake the row here
//            return
//        }

        let guess = grid[currentRow]
                    .map { $0.letter }
                    .joined()
                    .uppercased()          // normalize to UPPERCASE

        // now test against the set you just loaded
        guard Self.validWords.contains(guess) else {
            print("🚫 “\(guess)” not in validWords (count: \(Self.validWords.count))")
            showInvalidAlert = true
            return
        }
        
        var counts: [Character: Int] = [:]
        for ch in targetWord { counts[ch, default: 0] += 1 }
        // First pass: correct
        var states: [LetterState] = Array(repeating: .absent, count: 5)
        for i in 0..<5 {
            let idx = targetWord.index(targetWord.startIndex, offsetBy: i)
            let ch = guess[guess.index(guess.startIndex, offsetBy: i)]
            if ch == targetWord[idx] {
                states[i] = .correct
                counts[ch]? -= 1
            }
        }
        // Second pass: present or absent
        for i in 0..<5 {
            guard states[i] != .correct else { continue }
            let ch = guess[guess.index(guess.startIndex, offsetBy: i)]
            if let c = counts[ch], c > 0 {
                states[i] = .present
                counts[ch]? -= 1
            }
        }
        // Apply states & update keyboard
        for i in 0..<5 {
            let letter = grid[currentRow][i].letter
            let newState = states[i]
            grid[currentRow][i].state = newState
            let old = letterStates[letter] ?? .empty
            if newState == .correct
                || (newState == .present && old != .correct)
                || (newState == .absent && old == .empty) {
                letterStates[letter] = newState
            }
        }
//        // Move to next row
//        currentRow += 1
//        currentCol = 0
        
        // did the user win?
        let won = (guess == targetWord)
        didWin = won
        if won || currentRow == 5 {
                showResult = true
        } else {
            // otherwise move to next row
            currentRow += 1
            currentCol = 0
        }
    }
    
    private func resetGame() {
        // clear grid
        grid = Array(repeating: Array(repeating: ("", .empty), count: 5), count: 6)
        letterStates = [:]
        currentRow = 0
        currentCol = 0
        targetWord = WordBank.randomWord().uppercased()
        showResult = false
    }
}

struct WordleView_Previews: PreviewProvider {
    static var previews: some View { WordleView() }
}
