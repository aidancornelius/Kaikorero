//
//  ProgressViewModel.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class ProgressViewModel {
    private let wordDataService: WordDataService
    private let srsService: SRSService
    private let modelContext: ModelContext

    var totalWordsLearned = 0
    var totalReviews = 0
    var overallAccuracy: Double = 0
    var currentStreak = 0
    var wordsToReview = 0
    var upcomingReviews: [(date: Date, count: Int)] = []

    init(wordDataService: WordDataService, srsService: SRSService, modelContext: ModelContext) {
        self.wordDataService = wordDataService
        self.srsService = srsService
        self.modelContext = modelContext
    }

    func refresh() {
        loadStats()
        loadUpcomingReviews()
    }

    private func loadStats() {
        let progressDescriptor = FetchDescriptor<WordProgress>()
        let allProgress = (try? modelContext.fetch(progressDescriptor)) ?? []

        totalWordsLearned = allProgress.filter { $0.repetitions > 0 }.count

        let resultsDescriptor = FetchDescriptor<QuizResult>()
        let allResults = (try? modelContext.fetch(resultsDescriptor)) ?? []

        totalReviews = allResults.count
        let correctResults = allResults.filter(\.wasCorrect).count
        overallAccuracy = allResults.isEmpty ? 0 : Double(correctResults) / Double(allResults.count)

        wordsToReview = allProgress.filter { srsService.isDue($0) }.count

        currentStreak = calculateStreak(results: allResults)
    }

    private func loadUpcomingReviews() {
        let descriptor = FetchDescriptor<WordProgress>()
        let allProgress = (try? modelContext.fetch(descriptor)) ?? []

        let calendar = Calendar.current
        var reviewsByDay: [Date: Int] = [:]

        for progress in allProgress {
            guard let nextReview = progress.nextReviewDate else { continue }
            let day = calendar.startOfDay(for: nextReview)
            // Only show next 14 days
            if day <= Date().adding(days: 14) {
                reviewsByDay[day, default: 0] += 1
            }
        }

        upcomingReviews = reviewsByDay
            .sorted { $0.key < $1.key }
            .map { (date: $0.key, count: $0.value) }
    }

    private func calculateStreak(results: [QuizResult]) -> Int {
        guard !results.isEmpty else { return 0 }

        let calendar = Calendar.current
        let uniqueDays = Set(results.map { calendar.startOfDay(for: $0.timestamp) })
        let sortedDays = uniqueDays.sorted(by: >)

        guard let mostRecent = sortedDays.first else { return 0 }

        // Streak must include today or yesterday
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        guard mostRecent >= yesterday else { return 0 }

        var streak = 0
        var expectedDay = mostRecent

        for day in sortedDays {
            if day == expectedDay {
                streak += 1
                expectedDay = calendar.date(byAdding: .day, value: -1, to: expectedDay)!
            } else {
                break
            }
        }

        return streak
    }
}
