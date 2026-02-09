//
//  QuizResult.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData

@Model
class QuizResult {
    var id: UUID = UUID()
    var wordId: String = ""
    var quizType: Int = 0 // 0=multiChoice, 1=reverseChoice, 2=trueFalse, 3=listenChoose
    var wasCorrect: Bool = false
    var timestamp: Date = Date()

    init(wordId: String, quizType: Int, wasCorrect: Bool) {
        self.id = UUID()
        self.wordId = wordId
        self.quizType = quizType
        self.wasCorrect = wasCorrect
        self.timestamp = Date()
    }
}
