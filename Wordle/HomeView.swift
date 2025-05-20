//
//  HomeView.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 20/05/2025.
//

import SwiftUI

struct HomePageView: View {
    @State private var animateGradient = false
    @State private var showUI = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated gradient background
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue, .mint, .cyan]),
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateGradient)
                .onAppear { animateGradient = true }

                VStack(spacing: 30) {
                    Spacer()

                    // Glassmorphic welcome card
                    VStack(spacing: 10) {
                        Text("🧠 WordleX")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 8)

                        Text("Sharpen your brain — one word at a time")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .padding(.horizontal)
                    .opacity(showUI ? 1 : 0)
                    .offset(y: showUI ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.3), value: showUI)

                    Spacer()

                    // Buttons
                    VStack(spacing: 16) {
                        NavigationLink {
                            WordleView()
                        } label: {
                            Label("Play as Human", systemImage: "person.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(FancyButtonStyle(color: .blue))
                        .opacity(showUI ? 1 : 0)
                        .offset(y: showUI ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.5), value: showUI)

                        NavigationLink {
                            InfoTheoryView()
                        } label: {
                            Label("AI Solver Mode", systemImage: "brain.head.profile")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(FancyButtonStyle(color: .green))
                        .opacity(showUI ? 1 : 0)
                        .offset(y: showUI ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.7), value: showUI)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                .onAppear { showUI = true }
            }
            .navigationBarHidden(true)
        }
    }
}

// Custom button style
struct FancyButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.gradient)
                    .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 5)
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
