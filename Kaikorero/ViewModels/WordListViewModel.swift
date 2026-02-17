//
//  WordListViewModel.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class WordListViewModel {
    private let wordDataService: WordDataService
    private let modelContext: ModelContext

    var currentBatchWords: [WordEntry] = []
    var selectedTopic: Topic?
    private(set) var addedWordIDs: Set<String> = []

    init(wordDataService: WordDataService, modelContext: ModelContext) {
        self.wordDataService = wordDataService
        self.modelContext = modelContext
        reloadAddedWordIDs()
    }

    private func reloadAddedWordIDs() {
        let allProgress = fetchAllProgress()
        addedWordIDs = Set(allProgress.map(\.wordId))
    }

    var topics: [Topic] {
        wordDataService.topics
    }

    func words(for topic: Topic) -> [WordEntry] {
        wordDataService.words(for: topic.id)
    }

    func wordCount(for topic: Topic) -> Int {
        wordDataService.wordCount(for: topic.id)
    }

    func loadCurrentBatch() {
        let settings = fetchOrCreateSettings()

        reloadAddedWordIDs()

        // Check if we need a new batch
        let daysSinceBatchStart = Calendar.current.dateComponents(
            [.day],
            from: settings.currentBatchStartDate,
            to: Date()
        ).day ?? 0

        if addedWordIDs.isEmpty || daysSinceBatchStart >= settings.batchIntervalDays {
            addNewBatch(settings: settings, existingWordIDs: addedWordIDs)
        }

        // Load current batch words
        let recentProgress = fetchAllProgress().sorted { $0.dateAdded > $1.dateAdded }
        let batchWordIDs = recentProgress.prefix(settings.wordsPerBatch).map(\.wordId)
        currentBatchWords = batchWordIDs.compactMap { wordDataService.word(for: $0) }
    }

    func isWordAdded(_ wordID: String) -> Bool {
        addedWordIDs.contains(wordID)
    }

    func addWord(_ word: WordEntry) {
        guard !addedWordIDs.contains(word.id) else { return }
        let progress = WordProgress(wordId: word.id)
        modelContext.insert(progress)
        try? modelContext.save()
        addedWordIDs.insert(word.id)
    }

    func removeWord(_ wordID: String) {
        let descriptor = FetchDescriptor<WordProgress>(
            predicate: #Predicate { $0.wordId == wordID }
        )
        if let progress = try? modelContext.fetch(descriptor).first {
            modelContext.delete(progress)
            try? modelContext.save()
            addedWordIDs.remove(wordID)
            currentBatchWords.removeAll { $0.id == wordID }
        }
    }

    func refreshBatch() {
        reloadAddedWordIDs()
        let settings = fetchOrCreateSettings()
        addNewBatch(settings: settings, existingWordIDs: addedWordIDs)
        loadCurrentBatch()
    }

    func progressForWord(_ wordID: String) -> WordProgress? {
        let descriptor = FetchDescriptor<WordProgress>(
            predicate: #Predicate { $0.wordId == wordID }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func addNewBatch(settings: LearnerSettings, existingWordIDs: Set<String>) {
        // Find words not yet added, shuffled for variety
        let available = wordDataService.words
            .filter { !existingWordIDs.contains($0.id) }
            .shuffled()

        let newWords = Array(available.prefix(settings.wordsPerBatch))

        for word in newWords {
            let progress = WordProgress(wordId: word.id)
            modelContext.insert(progress)
        }

        settings.currentBatchStartDate = Date()
        try? modelContext.save()
    }

    private func fetchOrCreateSettings() -> LearnerSettings {
        let descriptor = FetchDescriptor<LearnerSettings>()
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let settings = LearnerSettings()
        modelContext.insert(settings)
        try? modelContext.save()
        return settings
    }

    private func fetchAllProgress() -> [WordProgress] {
        let descriptor = FetchDescriptor<WordProgress>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
