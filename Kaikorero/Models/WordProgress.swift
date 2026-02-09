//
//  WordProgress.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData

@Model
class WordProgress {
    var id: UUID = UUID()
    var wordId: String = ""
    var stability: Double = 0
    var difficulty: Double = 0.3
    var elapsedDays: Double = 0
    var scheduledDays: Double = 0
    var lastReviewDate: Date?
    var nextReviewDate: Date?
    var repetitions: Int = 0
    var lapses: Int = 0
    var cardState: Int = 0 // 0=new, 1=learning, 2=review, 3=relearning
    var dateAdded: Date = Date()

    init(wordId: String) {
        self.id = UUID()
        self.wordId = wordId
        self.dateAdded = Date()
    }
}
