//
//  ConfettiView.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 12/05/2025.
//

import SwiftUI
import UIKit

// 1) A UIView that hosts a CAEmitterLayer emitting confetti.
class ConfettiEmitterView: UIView {
    private var emitter: CAEmitterLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupEmitter()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupEmitter() {
        emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: bounds.size.width, height: 2)

        let colors: [UIColor] = [.systemPink, .systemYellow, .systemGreen, .systemBlue, .systemOrange]
        emitter.emitterCells = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate        = 4
            cell.lifetime         = 10.0
            cell.velocity         = 150
            cell.velocityRange    = 50
            cell.emissionLongitude = .pi
            cell.spin             = 4
            cell.spinRange        = 2
            cell.scale            = 0.05
            cell.scaleRange       = 0.02
            cell.color            = color.cgColor
            cell.contents         = UIImage(systemName: "circle.fill")?.cgImage
            return cell
        }

        layer.addSublayer(emitter)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: -10)
        emitter.emitterSize     = CGSize(width: bounds.size.width, height: 2)
    }

    func startConfetti() {
        emitter.birthRate = 1.0
        emitter.beginTime = CACurrentMediaTime()
    }

    func stopConfetti() {
        emitter.birthRate = 0
    }
}

// 2) SwiftUI wrapper
struct ConfettiView: UIViewRepresentable {
    @Binding var isActive: Bool

    func makeUIView(context: Context) -> ConfettiEmitterView {
        ConfettiEmitterView()
    }

    func updateUIView(_ uiView: ConfettiEmitterView, context: Context) {
        if isActive {
            uiView.startConfetti()
        } else {
            uiView.stopConfetti()
        }
    }
}
