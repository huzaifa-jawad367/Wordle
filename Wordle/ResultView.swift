//
//  ResultView.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 12/05/2025.
//

import SwiftUI

struct ResultView: View {
    let success: Bool
    let word: String
    let onRetry: () -> Void

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: success ? [Color.green.opacity(0.6), Color.green] : [Color.red.opacity(0.6), Color.red]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Icon
                Image(systemName: success ? "checkmark.seal.fill" : "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                // Title
                Text(success ? "Congratulations!" : "Better Luck Next Time")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                // Subtitle
                if success {
                    Text("You guessed the word correctly.")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                } else {
                    Text("The word was \"\(word)\".")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                }

                // Spacer pushes content up
                Spacer(minLength: 40)

                // Retry Button
                Button(action: onRetry) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultView(success: true, word: "APPLE") { }
            ResultView(success: false, word: "APPLE") { }
        }
    }
}

