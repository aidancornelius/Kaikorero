//
//  TopicListView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct TopicListView: View {
    let wordListViewModel: WordListViewModel
    let audioViewModel: AudioViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(wordListViewModel.topics) { topic in
                    NavigationLink {
                        KupuListView(
                            topic: topic,
                            wordListViewModel: wordListViewModel,
                            audioViewModel: audioViewModel
                        )
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: topic.iconName)
                                .font(.title2)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.teReo)
                                    .font(.headline)
                                Text(topic.english)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("\(wordListViewModel.wordCount(for: topic))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.fill.tertiary)
                                .clipShape(Capsule())
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Ngā Kaupapa")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Ngā Kaupapa",
                        english: "Topics",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
        }
    }
}
