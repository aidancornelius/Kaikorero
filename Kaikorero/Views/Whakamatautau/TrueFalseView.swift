//
//  TrueFalseView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

/// Standalone true/false question layout.
struct TrueFalseView: View {
    let prompt: String
    let isCorrectPair: Bool
    var onAnswer: ((Bool) -> Void)?

    @State private var answered = false
    @State private var wasCorrect = false

    var body: some View {
        VStack(spacing: 32) {
            Text(prompt)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if answered {
                HStack {
                    Image(systemName: wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text(wasCorrect ? "Tika! — Correct!" : "Hē — Incorrect")
                }
                .font(.headline)
                .foregroundStyle(wasCorrect ? .green : .red)
            }

            HStack(spacing: 20) {
                Button {
                    submitAnswer(userSaidTrue: true)
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.largeTitle)
                        Text("Āe")
                            .font(.headline)
                        Text("Yes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(buttonBackground(isTrue: true))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(answered)

                Button {
                    submitAnswer(userSaidTrue: false)
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.largeTitle)
                        Text("Kāo")
                            .font(.headline)
                        Text("No")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(buttonBackground(isTrue: false))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(answered)
            }
            .padding(.horizontal)
            .tint(.primary)
        }
    }

    private func submitAnswer(userSaidTrue: Bool) {
        guard !answered else { return }
        answered = true
        wasCorrect = (userSaidTrue == isCorrectPair)
        onAnswer?(wasCorrect)
    }

    private func buttonBackground(isTrue: Bool) -> some ShapeStyle {
        if answered {
            if isTrue == isCorrectPair {
                return AnyShapeStyle(.green.opacity(0.15))
            } else {
                return AnyShapeStyle(.red.opacity(0.15))
            }
        }
        return AnyShapeStyle(.fill.tertiary)
    }
}

#Preview {
    TrueFalseView(
        prompt: "kōrero = to speak",
        isCorrectPair: true
    )
}
