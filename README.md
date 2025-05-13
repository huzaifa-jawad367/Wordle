# Wordle

A SwiftUI-based clone of the popular Wordle game! Guess the five-letter secret word in six tries, with color-coded feedback and an on-screen keyboard. Includes daily puzzles, word list validation, and a polished results screen with confetti animation.

## 📝 Demo

https://github.com/user-attachments/assets/96988fda-ae58-43fc-bf4e-768ecceee2fa

## 🚀 Features

* 6×5 Grid: Enter guesses into a 6-row, 5-column grid

* Color Feedback:

  * 🟩 Correct position

  * 🟨 Present but wrong position

  * ⬜ Absent letter

On-Screen Keyboard: Colors update to reflect letter states

Word Validation: Checks guesses against a bundled JSON word list

Dynamic Daily Word: Pulls a random word (or your custom daily puzzle) from WordList.json

Result Screen:

Gradient background (green/red)

Success/fail titles & icons

Confetti animation on success

“Try Again” button to reset the game

Clean Architecture:

WordBank loads words from JSON

WordleGame logic separated from UI (recommended refactor)

Easy-to-extend for themed modes, leaderboards, etc.
