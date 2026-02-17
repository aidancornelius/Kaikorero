//
//  Whakatauki.swift
//  Kaikorero
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

struct Whakatauki: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let teReo: String
    let english: String
    let blankedText: String
    let targetWordId: String

    /// Audio of the proverb with the target word omitted (a pause in its place)
    var blankedAudioFileName: String { "\(id)-blanked.m4a" }

    /// Audio of the complete proverb
    var fullAudioFileName: String { "\(id).m4a" }
}
