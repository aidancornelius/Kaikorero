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
}
