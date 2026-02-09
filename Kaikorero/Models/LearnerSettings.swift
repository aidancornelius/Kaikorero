//
//  LearnerSettings.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData

@Model
class LearnerSettings {
    var id: UUID = UUID()
    var wordsPerBatch: Int = 10
    var batchIntervalDays: Int = 7
    var includeReviewWords: Bool = true
    var currentBatchStartDate: Date = Date()

    init() {
        self.id = UUID()
        self.currentBatchStartDate = Date()
    }
}
