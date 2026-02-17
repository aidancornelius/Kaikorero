//
//  WordEntry.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

struct WordEntry: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let teReo: String
    let english: String
    let alternativeTranslations: [String]
    let partOfSpeech: String
    let exampleSentence: String?
    let exampleTranslation: String?
    let audioFileName: String?
    let notes: String?
    let topic: String
    let difficulty: Int
    let pluralForm: String?
    let sentenceAudioFileName: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        teReo = try container.decode(String.self, forKey: .teReo)
        english = try container.decode(String.self, forKey: .english)
        alternativeTranslations = try container.decode([String].self, forKey: .alternativeTranslations)
        partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        exampleSentence = try container.decodeIfPresent(String.self, forKey: .exampleSentence)
        exampleTranslation = try container.decodeIfPresent(String.self, forKey: .exampleTranslation)
        audioFileName = try container.decodeIfPresent(String.self, forKey: .audioFileName)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        topic = try container.decode(String.self, forKey: .topic)
        difficulty = try container.decode(Int.self, forKey: .difficulty)
        pluralForm = try container.decodeIfPresent(String.self, forKey: .pluralForm)
        sentenceAudioFileName = try container.decodeIfPresent(String.self, forKey: .sentenceAudioFileName)
    }
}
