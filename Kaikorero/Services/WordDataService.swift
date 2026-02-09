//
//  WordDataService.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

#if !SWIFT_PACKAGE
private extension Bundle {
    static let module = Bundle.main
}
#endif

@Observable
final class WordDataService: Sendable {
    let words: [WordEntry]
    let topics: [Topic]

    private let wordsByTopic: [String: [WordEntry]]
    private let wordsByID: [String: WordEntry]

    init() {
        let loadedTopics = Self.loadTopics()
        let loadedWords = Self.loadWords()

        self.topics = loadedTopics.sorted { $0.sortOrder < $1.sortOrder }
        self.words = loadedWords
        self.wordsByTopic = Dictionary(grouping: loadedWords, by: \.topic)
        self.wordsByID = Dictionary(uniqueKeysWithValues: loadedWords.map { ($0.id, $0) })
    }

    func word(for id: String) -> WordEntry? {
        wordsByID[id]
    }

    func words(for topicID: String) -> [WordEntry] {
        wordsByTopic[topicID] ?? []
    }

    func words(forDifficulty difficulty: Int) -> [WordEntry] {
        words.filter { $0.difficulty == difficulty }
    }

    func wordCount(for topicID: String) -> Int {
        wordsByTopic[topicID]?.count ?? 0
    }

    func beginnerWords(limit: Int) -> [WordEntry] {
        Array(words.filter { $0.difficulty == 1 }.prefix(limit))
    }

    func distractors(for word: WordEntry, count: Int) -> [WordEntry] {
        let candidates = words.filter { candidate in
            candidate.id != word.id &&
            (candidate.topic == word.topic || candidate.difficulty == word.difficulty)
        }.shuffled()

        if candidates.count >= count {
            return Array(candidates.prefix(count))
        }

        let remaining = words.filter { $0.id != word.id && !candidates.contains($0) }.shuffled()
        return Array((candidates + remaining).prefix(count))
    }

    private static func loadWords() -> [WordEntry] {
        guard let url = Bundle.module.url(forResource: "words", withExtension: "json") else {
            assertionFailure("words.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([WordEntry].self, from: data)
        } catch {
            assertionFailure("Failed to decode words.json: \(error)")
            return []
        }
    }

    private static func loadTopics() -> [Topic] {
        guard let url = Bundle.module.url(forResource: "topics", withExtension: "json") else {
            assertionFailure("topics.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Topic].self, from: data)
        } catch {
            assertionFailure("Failed to decode topics.json: \(error)")
            return []
        }
    }
}
