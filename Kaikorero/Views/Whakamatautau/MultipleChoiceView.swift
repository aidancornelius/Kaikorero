//
//  MultipleChoiceView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

/// Standalone multiple choice question layout — can be used independently
/// of QuizSessionView for embedding in other contexts.
struct MultipleChoiceView: View {
    let prompt: String
    let options: [String]
    let correctIndex: Int
    var onAnswer: ((Bool) -> Void)?

    @State private var selectedIndex: Int?
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 24) {
            Text(prompt)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard !showResult else { return }
                        selectedIndex = index
                        showResult = true
                        onAnswer?(index == correctIndex)
                    } label: {
                        HStack {
                            Text(option)
                                .font(.body)

                            Spacer()

                            if showResult {
                                if index == correctIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if index == selectedIndex {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding()
                        .background(optionBackground(index: index))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .tint(.primary)
                }
            }
            .padding(.horizontal)
        }
    }

    private func optionBackground(index: Int) -> some ShapeStyle {
        if showResult {
            if index == correctIndex {
                return AnyShapeStyle(.green.opacity(0.15))
            } else if index == selectedIndex {
                return AnyShapeStyle(.red.opacity(0.15))
            }
        }
        return AnyShapeStyle(.fill.tertiary)
    }
}

#Preview {
    MultipleChoiceView(
        prompt: "kōrero",
        options: ["to eat", "to speak", "to walk", "to sleep"],
        correctIndex: 1
    )
}
