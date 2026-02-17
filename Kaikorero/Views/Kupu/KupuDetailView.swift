//
//  KupuDetailView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct KupuDetailView: View {
    let word: WordEntry
    let audioViewModel: AudioViewModel
    var wordListViewModel: WordListViewModel?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text(word.teReo)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        Text(word.partOfSpeech)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.fill.tertiary)
                            .clipShape(Capsule())

                        if let audioFile = word.audioFileName {
                            AudioPlayButton(fileName: audioFile, audioViewModel: audioViewModel)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                Divider()

                // Translation
                VStack(alignment: .leading, spacing: 8) {
                    sectionHeader(teReo: "Whakamāoritanga", english: "Translation")

                    Text(word.english)
                        .font(.title3)

                    if !word.alternativeTranslations.isEmpty {
                        Text("Also: \(word.alternativeTranslations.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                // Example sentence
                if let sentence = word.exampleSentence {
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader(teReo: "Tauira Rerenga", english: "Example Sentence")

                        Text(sentence)
                            .font(.body)
                            .italic()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.fill.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        if let translation = word.exampleTranslation {
                            Text(translation)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }
                    }
                }

                // Plural form
                if let plural = word.pluralForm {
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader(teReo: "Taurahi", english: "Plural")

                        Text(plural)
                            .font(.title3)
                    }
                }

                // Notes
                if let notes = word.notes {
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader(teReo: "Kōrero", english: "Notes")

                        Text(notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            if let vm = wordListViewModel {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        if vm.isWordAdded(word.id) {
                            vm.removeWord(word.id)
                        } else {
                            vm.addWord(word)
                        }
                    } label: {
                        if vm.isWordAdded(word.id) {
                            Label("Tango", systemImage: "checkmark.circle.fill")
                        } else {
                            Label("Tāpiri", systemImage: "plus.circle")
                        }
                    }
                }
            }
        }
    }

    private func sectionHeader(teReo: String, english: String) -> some View {
        BilingualLabel(
            teReo: teReo,
            english: english,
            teReoFont: .headline,
            englishFont: .caption
        )
    }
}
