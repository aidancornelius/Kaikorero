//
//  QuizPackDetailView.swift
//  Kaikorero
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct QuizPackDetailView: View {
    let pack: QuizPack
    let wordDataService: WordDataService
    let quizViewModel: QuizViewModel
    let audioViewModel: AudioViewModel

    private var words: [WordEntry] {
        wordDataService.words(for: pack)
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: pack.iconName)
                        .font(.largeTitle)
                        .foregroundStyle(Color.accentColor)

                    Text(pack.teReo)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(pack.english)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("\(words.count) kupu")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.fill.tertiary)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            Section {
                ForEach(words) { word in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.teReo)
                                .font(.headline)
                            Text(word.english)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if let audioFile = word.audioFileName {
                            AudioPlayButton(fileName: audioFile, audioViewModel: audioViewModel)
                        }
                    }
                    .padding(.vertical, 2)
                }
            } header: {
                BilingualLabel(
                    teReo: "Ngā Kupu",
                    english: "Words",
                    teReoFont: .subheadline,
                    englishFont: .caption2
                )
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
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                BilingualLabel(
                    teReo: pack.teReo,
                    english: pack.english,
                    teReoFont: .headline,
                    englishFont: .caption,
                    alignment: .center
                )
            }
        }
        .onAppear {
            quizViewModel.startPackQuiz(words: words)
        }
    }
}
