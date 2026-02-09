//
//  QuizSessionView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct QuizSessionView: View {
    let quizViewModel: QuizViewModel
    let audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: quizViewModel.progress)
                .tint(Color.accentColor)
                .padding(.horizontal)
                .accessibilityLabel("Question \(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.questions.count)")

            HStack {
                Text("\(quizViewModel.currentQuestionIndex + 1)/\(quizViewModel.questions.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 12) {
                    Label("\(quizViewModel.correctCount)", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .accessibilityLabel("\(quizViewModel.correctCount) correct")
                    Label("\(quizViewModel.incorrectCount)", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .accessibilityLabel("\(quizViewModel.incorrectCount) incorrect")
                }
                .font(.caption)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()

            if quizViewModel.quizComplete {
                QuizResultsView(quizViewModel: quizViewModel)
            } else if let question = quizViewModel.currentQuestion {
                questionContent(question)
            } else {
                ContentUnavailableView(
                    "Kāore he pātai",
                    systemImage: "questionmark.circle",
                    description: Text("No questions available. Add more words to your learning list.")
                )
            }

            Spacer()
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Mutu") { dismiss() }
            }
        }
        .onAppear {
            quizViewModel.startQuiz()
        }
    }

    /// Only auto-play when the prompt shows te reo (not English)
    private var promptIsTeReo: Bool {
        guard let q = quizViewModel.currentQuestion else { return false }
        return q.type == .multipleChoice || q.type == .trueFalse
    }

    private func playAudioIfAvailable(for question: QuizQuestion) {
        guard quizViewModel.autoPlayAudio,
              let audioFile = question.word.audioFileName,
              question.type != .listenChoose,
              question.type != .reverseChoice // English prompt — don't auto-play
        else { return }
        audioViewModel.play(fileName: audioFile)
    }

    @ViewBuilder
    private func questionContent(_ question: QuizQuestion) -> some View {
        VStack(spacing: 32) {
            // Question prompt
            VStack(spacing: 8) {
                Text(question.type.teReo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text(question.displayText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if let audioFile = question.word.audioFileName, promptIsTeReo {
                    Button {
                        audioViewModel.play(fileName: audioFile)
                    } label: {
                        Image(systemName: audioViewModel.isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                            .symbolEffect(.variableColor.iterative, isActive: audioViewModel.isPlaying)
                    }
                    .accessibilityLabel("Play pronunciation")
                    .padding(.top, 4)
                }
            }
            .onAppear {
                playAudioIfAvailable(for: question)
            }
            .onChange(of: quizViewModel.currentQuestionIndex) {
                if let q = quizViewModel.currentQuestion {
                    playAudioIfAvailable(for: q)
                }
            }

            // Answer options
            VStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    answerButton(
                        text: option,
                        index: index,
                        question: question
                    )
                }
            }
            .padding(.horizontal)

            // Next button (visible after answering)
            if quizViewModel.showingResult {
                Button {
                    quizViewModel.nextQuestion()
                } label: {
                    Text("Panuku — Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
        }
    }

    private func answerButton(text: String, index: Int, question: QuizQuestion) -> some View {
        Button {
            quizViewModel.selectAnswer(index)
            // For reverse choice (English→Te Reo), play audio of the selected te reo word
            if question.type == .reverseChoice,
               quizViewModel.autoPlayAudio,
               let audioFile = question.word.audioFileName {
                audioViewModel.play(fileName: audioFile)
            }
        } label: {
            HStack {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)

                Spacer()

                if quizViewModel.showingResult {
                    if index == question.correctAnswerIndex {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else if index == quizViewModel.selectedAnswerIndex {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }

                // Show speaker icon on te reo answers (reverse choice) after answering
                if question.type == .reverseChoice,
                   quizViewModel.showingResult,
                   index == question.correctAnswerIndex,
                   question.word.audioFileName != nil {
                    Button {
                        if let audioFile = question.word.audioFileName {
                            audioViewModel.play(fileName: audioFile)
                        }
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(answerBackground(index: index, correctIndex: question.correctAnswerIndex))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(quizViewModel.showingResult)
        .tint(.primary)
        .accessibilityLabel(text)
        .accessibilityHint(quizViewModel.showingResult ? (index == question.correctAnswerIndex ? "Correct answer" : "") : "Select this answer")
    }

    private func answerBackground(index: Int, correctIndex: Int) -> some ShapeStyle {
        if quizViewModel.showingResult {
            if index == correctIndex {
                return AnyShapeStyle(.green.opacity(0.15))
            } else if index == quizViewModel.selectedAnswerIndex {
                return AnyShapeStyle(.red.opacity(0.15))
            }
        }
        return AnyShapeStyle(.fill.tertiary)
    }
}
