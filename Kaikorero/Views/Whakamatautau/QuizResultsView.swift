//
//  QuizResultsView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct QuizResultsView: View {
    let quizViewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // Score circle
            ZStack {
                Circle()
                    .stroke(.fill.tertiary, lineWidth: 12)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: Double(quizViewModel.scorePercentage) / 100)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(quizViewModel.scorePercentage)%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(scoreLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Stats
            HStack(spacing: 32) {
                statItem(
                    value: "\(quizViewModel.correctCount)",
                    label: "Tika",
                    sublabel: "Correct",
                    color: .green
                )
                statItem(
                    value: "\(quizViewModel.incorrectCount)",
                    label: "Hē",
                    sublabel: "Incorrect",
                    color: .red
                )
                statItem(
                    value: "\(quizViewModel.questions.count)",
                    label: "Katoa",
                    sublabel: "Total",
                    color: .blue
                )
            }

            // Word results list
            if !quizViewModel.answeredWords.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    BilingualLabel(
                        teReo: "Ngā Hua",
                        english: "Results",
                        teReoFont: .headline,
                        englishFont: .caption
                    )
                    .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(Array(quizViewModel.answeredWords.enumerated()), id: \.offset) { _, item in
                                HStack {
                                    Image(systemName: item.wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(item.wasCorrect ? .green : .red)

                                    Text(item.word.teReo)
                                        .font(.subheadline)
                                        .fontWeight(.medium)

                                    Spacer()

                                    Text(item.word.english)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }

            Button {
                dismiss()
            } label: {
                Text("Ka pai — Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }

    private var scoreColor: Color {
        switch quizViewModel.scorePercentage {
        case 80...100: .green
        case 60..<80: .orange
        default: .red
        }
    }

    private var scoreLabel: String {
        switch quizViewModel.scorePercentage {
        case 90...100: "Rawe! — Excellent!"
        case 80..<90: "Ka pai! — Great!"
        case 60..<80: "Pai — Good"
        default: "Kia kaha — Keep going"
        }
    }

    private func statItem(value: String, label: String, sublabel: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
            Text(sublabel)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
