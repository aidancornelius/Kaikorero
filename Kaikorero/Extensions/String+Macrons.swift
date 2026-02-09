//
//  String+Macrons.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

extension String {
    /// Mapping of vowels to their macron (tohutō) equivalents.
    private static let macronMap: [Character: Character] = [
        "a": "ā", "e": "ē", "i": "ī", "o": "ō", "u": "ū",
        "A": "Ā", "E": "Ē", "I": "Ī", "O": "Ō", "U": "Ū",
    ]

    private static let demacronMap: [Character: Character] = [
        "ā": "a", "ē": "e", "ī": "i", "ō": "o", "ū": "u",
        "Ā": "A", "Ē": "E", "Ī": "I", "Ō": "O", "Ū": "U",
    ]

    /// Returns the string with macrons stripped (e.g. "kōrero" → "korero").
    var withoutMacrons: String {
        String(map { Self.demacronMap[$0] ?? $0 })
    }

    /// Returns true if the string contains any macronised vowels.
    var containsMacrons: Bool {
        contains { Self.demacronMap[$0] != nil }
    }

    /// Case-insensitive comparison that ignores macrons.
    func equalsIgnoringMacrons(_ other: String) -> Bool {
        withoutMacrons.lowercased() == other.withoutMacrons.lowercased()
    }
}
