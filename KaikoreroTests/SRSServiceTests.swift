//
//  SRSServiceTests.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Testing
import Foundation
@testable import Kaikorero

@Suite("SRSService Tests")
struct SRSServiceTests {

    @Test("New card is due")
    func newCardIsDue() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")
        #expect(service.isDue(progress), "New card should be due")
    }

    @Test("Review updates SRS state")
    func reviewUpdateState() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")

        let updated = service.review(progress: progress, rating: .good)

        #expect(updated.repetitions == 1)
        #expect(updated.lastReviewDate != nil)
        #expect(updated.nextReviewDate != nil)
        #expect(updated.stability > 0)
        #expect(updated.cardState == 2, "After good review, card should be in review state")
    }

    @Test("Rating for correctness")
    func ratingForCorrectness() {
        let service = SRSService()
        #expect(service.ratingForCorrectness(wasCorrect: true) == .good)
        #expect(service.ratingForCorrectness(wasCorrect: false) == .again)
    }

    @Test("Reviewed card with future due date is not due")
    func reviewedCardNotDue() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")
        _ = service.review(progress: progress, rating: .good)

        // After a good review, the next review should be in the future
        #expect(!service.isDue(progress), "Just-reviewed card should not be immediately due")
    }

    @Test("Failed review increases lapses")
    func failedReviewIncreasesLapses() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")

        // First review as good
        _ = service.review(progress: progress, rating: .good)
        let lapsesAfterGood = progress.lapses

        // Second review as again (failure)
        _ = service.review(progress: progress, rating: .again)
        #expect(progress.lapses > lapsesAfterGood, "Failed review should increase lapses")
    }

    @Test("Multiple reviews increase repetitions")
    func multipleReviews() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")

        _ = service.review(progress: progress, rating: .good)
        #expect(progress.repetitions == 1)

        _ = service.review(progress: progress, rating: .good)
        #expect(progress.repetitions == 2)

        _ = service.review(progress: progress, rating: .easy)
        #expect(progress.repetitions == 3)
    }

    @Test("Card from progress round-trip")
    func cardFromProgress() {
        let service = SRSService()
        let progress = WordProgress(wordId: "test-word")

        let card = service.card(from: progress)
        #expect(card.reps == 0)
        #expect(card.lapses == 0)
    }
}
