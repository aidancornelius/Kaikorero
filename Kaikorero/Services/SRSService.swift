//
//  SRSService.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftFSRS

@Observable
final class SRSService {
    private let scheduler: any Scheduler = SchedulerType.longTerm.implementation
    private let algorithm = FSRSAlgorithm.v5

    func card(from progress: WordProgress) -> Card {
        var card = Card()
        card.stability = progress.stability
        card.difficulty = progress.difficulty
        card.elapsedDays = progress.elapsedDays
        card.scheduledDays = progress.scheduledDays
        card.reps = progress.repetitions
        card.lapses = progress.lapses
        card.lastReview = progress.lastReviewDate

        switch progress.cardState {
        case 0: card.status = .new
        case 1: card.status = .learning
        case 2: card.status = .review
        case 3: card.status = .relearning
        default: card.status = .new
        }

        if let nextReview = progress.nextReviewDate {
            card.due = nextReview
        }

        return card
    }

    func review(progress: WordProgress, rating: Rating, at date: Date = Date()) -> WordProgress {
        let card = card(from: progress)
        let result = scheduler.schedule(
            card: card,
            algorithm: algorithm,
            reviewRating: rating,
            reviewTime: date
        )

        let updated = result.postReviewCard
        progress.stability = updated.stability
        progress.difficulty = updated.difficulty
        progress.elapsedDays = updated.elapsedDays
        progress.scheduledDays = updated.scheduledDays
        progress.repetitions = updated.reps
        progress.lapses = updated.lapses
        progress.lastReviewDate = date
        progress.nextReviewDate = updated.due

        switch updated.status {
        case .new: progress.cardState = 0
        case .learning: progress.cardState = 1
        case .review: progress.cardState = 2
        case .relearning: progress.cardState = 3
        }

        return progress
    }

    func isDue(_ progress: WordProgress, at date: Date = Date()) -> Bool {
        guard let nextReview = progress.nextReviewDate else {
            return progress.cardState == 0 // New cards are always due
        }
        return nextReview <= date
    }

    func ratingForCorrectness(wasCorrect: Bool) -> Rating {
        wasCorrect ? .good : .again
    }
}
