//
//  InfoTheoryView.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 20/05/2025.
//

import SwiftUI

struct InfoTheoryView: View {
    @State private var stepIndex: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            // Simulated grid (replace with AI-controlled grid later)
            VStack(spacing: 4) {
                ForEach(0..<6) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray6))
                                .frame(width: 50, height: 50)
                        }
                    }
                }
            }
            .padding(.vertical)

            // Scrollable explanation/analytics area
            ScrollView {
                Text("Step-by-step solver logic, entropy, probabilities, and analysis will appear here.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .frame(height: 250)
            
            Spacer()

            // Navigation controls for AI steps
            HStack(spacing: 20) {
                Button(action: {
                    if stepIndex > 0 { stepIndex -= 1 }
                }) {
                    Label("Back", systemImage: "chevron.left")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.borderedProminent)

                Button(action: {
                    stepIndex += 1
                }) {
                    Label("Next", systemImage: "chevron.right")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 30)

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}
