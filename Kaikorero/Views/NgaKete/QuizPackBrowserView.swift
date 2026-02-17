//
//  QuizPackBrowserView.swift
//  Kaikorero
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct QuizPackBrowserView: View {
    let wordDataService: WordDataService
    let quizViewModel: QuizViewModel
    let audioViewModel: AudioViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(wordDataService.packCategories(), id: \.category) { category in
                    Section {
                        ForEach(category.packs) { pack in
                            NavigationLink {
                                QuizPackDetailView(
                                    pack: pack,
                                    wordDataService: wordDataService,
                                    quizViewModel: quizViewModel,
                                    audioViewModel: audioViewModel
                                )
                            } label: {
                                packRow(pack)
                            }
                        }
                    } header: {
                        BilingualLabel(
                            teReo: category.teReo,
                            english: category.english,
                            teReoFont: .subheadline,
                            englishFont: .caption2
                        )
                    }
                }
            }
            .navigationTitle("Ngā Kete")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Ngā Kete",
                        english: "Study Packs",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
        }
    }

    private func packRow(_ pack: QuizPack) -> some View {
        HStack(spacing: 14) {
            Image(systemName: pack.iconName)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(pack.teReo)
                    .font(.headline)
                Text(pack.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(pack.wordIds.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.fill.tertiary)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
        .accessibilityLabel("\(pack.teReo), \(pack.english), \(pack.wordIds.count) words")
    }
}
