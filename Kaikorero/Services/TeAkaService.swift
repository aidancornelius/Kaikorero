//
//  TeAkaService.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

/// Te Aka Māori Dictionary API client.
/// This is a stretch goal for v1 — the API requires manual outreach to obtain access.
@Observable
final class TeAkaService {
    var isLoading = false
    var lastError: String?

    struct DictionaryEntry: Codable, Sendable {
        let word: String
        let definition: String
        let partOfSpeech: String?
    }

    func lookup(word: String) async -> DictionaryEntry? {
        // TODO: Implement when Te Aka API access is obtained
        // For now, return nil to indicate no result
        isLoading = true
        defer { isLoading = false }

        // Placeholder — will be replaced with actual API call
        lastError = "Te Aka API integration is not yet available"
        return nil
    }
}
