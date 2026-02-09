//
//  QuizSetupView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct QuizSetupView: View {
    let quizViewModel: QuizViewModel
    let audioViewModel: AudioViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    BilingualLabel(
                        teReo: "Momo Pātai",
                        english: "Question Types",
                        teReoFont: .headline,
                        englishFont: .caption
                    )

                    ForEach(QuizType.allCases) { type in
                        if type != .listenChoose { // Audio requires bundled files
                            Button {
                                quizViewModel.toggleQuizType(type)
                            } label: {
                                HStack {
                                    Image(systemName: type.iconName)
                                        .frame(width: 24)
                                        .foregroundStyle(Color.accentColor)

                                    VStack(alignment: .leading) {
                                        Text(type.teReo)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text(type.english)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    if quizViewModel.selectedQuizTypes.contains(type) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.accentColor)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .tint(.primary)
                        }
                    }
                }

                Section {
                    BilingualLabel(
                        teReo: "Tautuhinga",
                        english: "Settings",
                        teReoFont: .headline,
                        englishFont: .caption
                    )

                    Stepper(
                        "Questions: \(quizViewModel.questionCount)",
                        value: Bindable(quizViewModel).questionCount,
                        in: 5...30,
                        step: 5
                    )

                    Toggle(isOn: Bindable(quizViewModel).includeReviewWords) {
                        VStack(alignment: .leading) {
                            Text("Include review words")
                                .font(.subheadline)
                            Text("Add words due for SRS review")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Toggle(isOn: Bindable(quizViewModel).autoPlayAudio) {
                        VStack(alignment: .leading) {
                            Text("Auto-play audio")
                                .font(.subheadline)
                            Text("Play pronunciation when a word appears")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    NavigationLink {
                        QuizSessionView(quizViewModel: quizViewModel, audioViewModel: audioViewModel)
                    } label: {
                        HStack {
                            Spacer()
                            Label("Tīmata — Start Quiz", systemImage: "play.fill")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .tint(Color.accentColor)
                }
            }
            .navigationTitle("Whakamātautau")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Whakamātautau",
                        english: "Quiz",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
        }
    }
}
