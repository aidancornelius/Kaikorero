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
    let quizPacks: [QuizPack]
    let whakatauki: [Whakatauki]

    private let wordsByTopic: [String: [WordEntry]]
    private let wordsByID: [String: WordEntry]
    private let whakataukiByTargetWord: [String: [Whakatauki]]

    init() {
        let loadedTopics = Self.loadTopics()
        let loadedWords = Self.loadWords()
        let loadedPacks = Self.loadQuizPacks()
        let loadedWhakatauki = Self.loadWhakatauki()

        self.topics = loadedTopics.sorted { $0.sortOrder < $1.sortOrder }
        self.words = loadedWords
        self.wordsByTopic = Dictionary(grouping: loadedWords, by: \.topic)
        self.wordsByID = Dictionary(uniqueKeysWithValues: loadedWords.map { ($0.id, $0) })
        self.quizPacks = loadedPacks.sorted { $0.sortOrder < $1.sortOrder }
        self.whakatauki = loadedWhakatauki
        self.whakataukiByTargetWord = Dictionary(grouping: loadedWhakatauki, by: \.targetWordId)
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

    func words(for pack: QuizPack) -> [WordEntry] {
        pack.wordIds.compactMap { wordsByID[$0] }
    }

    func packCategories() -> [(category: String, teReo: String, english: String, packs: [QuizPack])] {
        let grouped = Dictionary(grouping: quizPacks, by: \.category)
        let categories = grouped.map { (category, packs) in
            let first = packs.first!
            return (
                category: category,
                teReo: first.categoryTeReo,
                english: first.categoryEnglish,
                packs: packs.sorted { $0.sortOrder < $1.sortOrder }
            )
        }
        return categories.sorted { $0.packs.first?.sortOrder ?? 0 < $1.packs.first?.sortOrder ?? 0 }
    }

    func whakatauki(for wordID: String) -> Whakatauki? {
        whakataukiByTargetWord[wordID]?.randomElement()
    }

    func whakatauki(forAnyOf wordIDs: Set<String>) -> [Whakatauki] {
        whakatauki.filter { wordIDs.contains($0.targetWordId) }
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

    private static func loadQuizPacks() -> [QuizPack] {
        guard let url = Bundle.module.url(forResource: "quiz_packs", withExtension: "json") else {
            assertionFailure("quiz_packs.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([QuizPack].self, from: data)
        } catch {
            assertionFailure("Failed to decode quiz_packs.json: \(error)")
            return []
        }
    }

    private static func loadWhakatauki() -> [Whakatauki] {
        guard let url = Bundle.module.url(forResource: "whakatauki", withExtension: "json") else {
            assertionFailure("whakatauki.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Whakatauki].self, from: data)
        } catch {
            assertionFailure("Failed to decode whakatauki.json: \(error)")
            return []
        }
    }
}
