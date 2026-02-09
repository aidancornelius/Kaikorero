//
//  ContentView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var wordDataService = WordDataService()
    @State private var srsService = SRSService()
    @State private var audioService = AudioService()

    @State private var wordListViewModel: WordListViewModel?
    @State private var quizViewModel: QuizViewModel?
    @State private var progressViewModel: ProgressViewModel?
    @State private var audioViewModel: AudioViewModel?

    var body: some View {
        Group {
            if let wordListVM = wordListViewModel,
               let quizVM = quizViewModel,
               let progressVM = progressViewModel,
               let audioVM = audioViewModel {
                TabView {
                    Tab("Kupu", systemImage: "text.book.closed.fill") {
                        KupuTabView(
                            wordListViewModel: wordListVM,
                            audioViewModel: audioVM
                        )
                    }

                    Tab("Whakamātautau", systemImage: "questionmark.circle.fill") {
                        QuizSetupView(quizViewModel: quizVM, audioViewModel: audioVM)
                    }

                    Tab("Kauneke", systemImage: "chart.bar.fill") {
                        ProgressDashboardView(progressViewModel: progressVM)
                    }

                    Tab("Mōhiohio", systemImage: "info.circle.fill") {
                        AcknowledgementsView()
                    }
                }
                .tint(Color.accentColor)
            } else {
                ProgressView("Kei te uta…")
                    .onAppear { setupViewModels() }
            }
        }
    }

    private func setupViewModels() {
        let audioVM = AudioViewModel(audioService: audioService)
        let wordListVM = WordListViewModel(
            wordDataService: wordDataService,
            modelContext: modelContext
        )
        let quizService = QuizService(wordDataService: wordDataService)
        let quizVM = QuizViewModel(
            quizService: quizService,
            srsService: srsService,
            wordDataService: wordDataService,
            modelContext: modelContext
        )
        let progressVM = ProgressViewModel(
            wordDataService: wordDataService,
            srsService: srsService,
            modelContext: modelContext
        )

        self.audioViewModel = audioVM
        self.wordListViewModel = wordListVM
        self.quizViewModel = quizVM
        self.progressViewModel = progressVM

        wordListVM.loadCurrentBatch()
    }
}

/// Combined Kupu tab with topic browsing and current batch
struct KupuTabView: View {
    let wordListViewModel: WordListViewModel
    let audioViewModel: AudioViewModel

    var body: some View {
        NavigationStack {
            List {
                // Current batch section
                Section {
                    NavigationLink {
                        KupuListView(
                            topic: nil,
                            wordListViewModel: wordListViewModel,
                            audioViewModel: audioViewModel
                        )
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundStyle(.orange)
                                .frame(width: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Kupu o te Wiki")
                                    .font(.headline)
                                Text("Words of the Week")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("\(wordListViewModel.currentBatchWords.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.fill.tertiary)
                                .clipShape(Capsule())
                        }
                        .padding(.vertical, 4)
                    }
                    .accessibilityLabel("Words of the Week, \(wordListViewModel.currentBatchWords.count) words")
                } header: {
                    BilingualLabel(
                        teReo: "Tō Akoranga",
                        english: "Your Learning",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }

                // Browse by topic
                Section {
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
                                    .foregroundStyle(.white)
                                    .frame(width: 36, height: 36)
                                    .background(topic.color.gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

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
                        .accessibilityLabel("\(topic.teReo), \(topic.english), \(wordListViewModel.wordCount(for: topic)) words")
                    }
                } header: {
                    BilingualLabel(
                        teReo: "Ngā Kaupapa",
                        english: "Topics",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }
            }
            .navigationTitle("Kaikōrero")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Kaikōrero",
                        english: "Words",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
        }
    }
}
