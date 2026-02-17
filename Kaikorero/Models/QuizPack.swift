//
//  QuizPack.swift
//  Kaikorero
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

struct QuizPack: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let teReo: String
    let english: String
    let category: String
    let categoryTeReo: String
    let categoryEnglish: String
    let iconName: String
    let sortOrder: Int
    let wordIds: [String]
}
