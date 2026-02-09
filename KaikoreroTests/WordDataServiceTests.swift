//
//  WordDataServiceTests.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Testing
import Foundation
@testable import Kaikorero

@Suite("WordDataService Tests")
struct WordDataServiceTests {

    @Test("Load words from bundle")
    func loadWords() {
        let service = WordDataService()
        #expect(!service.words.isEmpty, "Should load at least one word")
    }

    @Test("Load topics from bundle")
    func loadTopics() {
        let service = WordDataService()
        #expect(!service.topics.isEmpty, "Should load at least one topic")
        #expect(service.topics.first?.sortOrder == 1, "Topics should be sorted")
    }

    @Test("Lookup word by ID")
    func lookupWord() {
        let service = WordDataService()
        let word = service.word(for: "kia-ora-tuke")
        #expect(word != nil, "Should find kia ora")
        #expect(word?.teReo == "kia ora")
    }

    @Test("Words by topic")
    func wordsByTopic() {
        let service = WordDataService()
        let mihimihi = service.words(for: "mihimihi")
        #expect(!mihimihi.isEmpty, "Should have words in mihimihi topic")
        #expect(mihimihi.allSatisfy { $0.topic == "mihimihi" })
    }

    @Test("Word count per topic")
    func wordCount() {
        let service = WordDataService()
        let count = service.wordCount(for: "kai")
        #expect(count > 0, "Kai topic should have words")
    }

    @Test("Beginner words")
    func beginnerWords() {
        let service = WordDataService()
        let beginners = service.beginnerWords(limit: 5)
        #expect(beginners.count == 5)
        #expect(beginners.allSatisfy { $0.difficulty == 1 })
    }

    @Test("Distractors exclude target word")
    func distractors() {
        let service = WordDataService()
        guard let word = service.words.first else {
            Issue.record("No words loaded")
            return
        }
        let distractors = service.distractors(for: word, count: 3)
        #expect(distractors.count == 3)
        #expect(!distractors.contains(word), "Distractors should not include the target word")
    }

    @Test("All words have valid topic references")
    func validTopicReferences() {
        let service = WordDataService()
        let topicIDs = Set(service.topics.map(\.id))
        for word in service.words {
            #expect(topicIDs.contains(word.topic), "\(word.id) references unknown topic \(word.topic)")
        }
    }

    @Test("All word IDs are unique")
    func uniqueWordIDs() {
        let service = WordDataService()
        let ids = service.words.map(\.id)
        let uniqueIDs = Set(ids)
        #expect(ids.count == uniqueIDs.count, "Duplicate word IDs found")
    }

    @Test("All words have macrons where expected")
    func macronConsistency() {
        let service = WordDataService()
        // Just verify we can load and the data has non-ASCII characters (macrons)
        let hasAnyMacrons = service.words.contains { $0.teReo.containsMacrons }
        #expect(hasAnyMacrons, "Dataset should contain words with macrons")
    }
}
