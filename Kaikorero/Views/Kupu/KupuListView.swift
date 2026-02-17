//
//  KupuListView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct KupuListView: View {
    let topic: Topic?
    let wordListViewModel: WordListViewModel
    let audioViewModel: AudioViewModel

    var words: [WordEntry] {
        if let topic {
            return wordListViewModel.words(for: topic)
        }
        return wordListViewModel.currentBatchWords
    }

    var title: String {
        topic?.teReo ?? "Kupu o te Wiki"
    }

    var subtitle: String {
        topic?.english ?? "Words of the Week"
    }

    var body: some View {
        List {
            ForEach(words) { word in
                NavigationLink {
                    KupuDetailView(
                        word: word,
                        audioViewModel: audioViewModel,
                        wordListViewModel: wordListViewModel
                    )
                } label: {
                    KupuRowView(word: word, wordListViewModel: wordListViewModel)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if wordListViewModel.isWordAdded(word.id) {
                        Button(role: .destructive) {
                            wordListViewModel.removeWord(word.id)
                        } label: {
                            Label("Tango", systemImage: "minus.circle.fill")
                        }
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    if !wordListViewModel.isWordAdded(word.id) {
                        Button {
                            wordListViewModel.addWord(word)
                        } label: {
                            Label("Tāpiri", systemImage: "plus.circle.fill")
                        }
                        .tint(.green)
                    }
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .principal) {
                BilingualLabel(
                    teReo: title,
                    english: subtitle,
                    teReoFont: .headline,
                    englishFont: .caption,
                    alignment: .center
                )
            }
            if topic == nil {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        wordListViewModel.refreshBatch()
                    } label: {
                        Label("Whakahōu", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
        }
        .onAppear {
            if topic == nil {
                wordListViewModel.loadCurrentBatch()
            }
        }
    }
}

private struct KupuRowView: View {
    let word: WordEntry
    let wordListViewModel: WordListViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.teReo)
                    .font(.headline)
                Text(word.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if wordListViewModel.isWordAdded(word.id) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.body)
            }

            difficultyBadge(word.difficulty)
        }
        .padding(.vertical, 4)
    }

    private func difficultyBadge(_ level: Int) -> some View {
        let (text, color): (String, Color) = switch level {
        case 1: ("Tīmata", .green)
        case 2: ("Takawaenga", .orange)
        case 3: ("Matatau", .red)
        default: ("", .gray)
        }

        return Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
