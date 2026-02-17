//
//  QuizViewModel.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftData
import SwiftFSRS

@Observable
@MainActor
final class QuizViewModel {
    private let quizService: QuizService
    private let srsService: SRSService
    private let wordDataService: WordDataService
    private let modelContext: ModelContext

    var questions: [QuizQuestion] = []
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int?
    var showingResult = false
    var quizComplete = false
    var correctCount = 0
    var incorrectCount = 0
    var answeredWords: [(word: WordEntry, wasCorrect: Bool)] = []

    // Setup options (synced via iCloud KV store)
    var selectedQuizTypes: Set<QuizType> = Set(QuizType.allCases) {
        didSet { Self.saveQuizTypes(selectedQuizTypes) }
    }
    var questionCount = 10
    var includeReviewWords = true
    var autoPlayAudio = true

    private static let quizTypesKey = "selectedQuizTypes"
    private static let kvStore = NSUbiquitousKeyValueStore.default

    init(
        quizService: QuizService,
        srsService: SRSService,
        wordDataService: WordDataService,
        modelContext: ModelContext
    ) {
        self.quizService = quizService
        self.srsService = srsService
        self.wordDataService = wordDataService
        self.modelContext = modelContext

        Self.kvStore.synchronize()
        if let saved = Self.kvStore.array(forKey: Self.quizTypesKey) as? [Int] {
            let types = saved.compactMap { QuizType(rawValue: $0) }
            if !types.isEmpty {
                self.selectedQuizTypes = Set(types)
            }
        }
    }

    private static func saveQuizTypes(_ types: Set<QuizType>) {
        kvStore.set(types.map(\.rawValue), forKey: quizTypesKey)
    }

    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }

    var scorePercentage: Int {
        let total = correctCount + incorrectCount
        guard total > 0 else { return 0 }
        return Int((Double(correctCount) / Double(total)) * 100)
    }

    // Words to use for pack quizzes (set before navigating to quiz session)
    var packWords: [WordEntry]?

    func startQuiz() {
        let words: [WordEntry]
        if let pack = packWords {
            words = pack
            packWords = nil
        } else {
            words = gatherQuizWords()
        }
        questions = quizService.generateQuiz(
            words: words,
            types: selectedQuizTypes,
            questionCount: questionCount
        )
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        showingResult = false
        quizComplete = false
        correctCount = 0
        incorrectCount = 0
        answeredWords = []
    }

    func startPackQuiz(words: [WordEntry]) {
        packWords = words
        // Set question count to match pack size, capped at 30
        questionCount = min(words.count, 30)
    }

    func selectAnswer(_ index: Int) {
        guard !showingResult, let question = currentQuestion else { return }
        selectedAnswerIndex = index
        showingResult = true

        let wasCorrect = index == question.correctAnswerIndex
        if wasCorrect {
            correctCount += 1
        } else {
            incorrectCount += 1
        }
        answeredWords.append((word: question.word, wasCorrect: wasCorrect))

        // Record quiz result
        let result = QuizResult(
            wordId: question.word.id,
            quizType: question.type.rawValue,
            wasCorrect: wasCorrect
        )
        modelContext.insert(result)
        try? modelContext.save()

        // Update SRS
        updateSRS(for: question.word, wasCorrect: wasCorrect)
    }

    func nextQuestion() {
        selectedAnswerIndex = nil
        showingResult = false
        currentQuestionIndex += 1

        if currentQuestionIndex >= questions.count {
            quizComplete = true
        }
    }

    func toggleQuizType(_ type: QuizType) {
        if selectedQuizTypes.contains(type) {
            if selectedQuizTypes.count > 1 {
                selectedQuizTypes.remove(type)
            }
        } else {
            selectedQuizTypes.insert(type)
        }
    }

    private func gatherQuizWords() -> [WordEntry] {
        let allProgress = fetchAllProgress()
        var wordIDs: [String] = []

        // Add due review words
        if includeReviewWords {
            let dueWords = allProgress.filter { srsService.isDue($0) }
            wordIDs.append(contentsOf: dueWords.map(\.wordId))
        }

        // Add current batch words
        let recentProgress = allProgress
            .sorted { $0.dateAdded > $1.dateAdded }
            .prefix(10)
        wordIDs.append(contentsOf: recentProgress.map(\.wordId))

        // Deduplicate
        let uniqueIDs = Array(Set(wordIDs))
        return uniqueIDs.compactMap { wordDataService.word(for: $0) }
    }

    private func updateSRS(for word: WordEntry, wasCorrect: Bool) {
        let progress = fetchOrCreateProgress(for: word.id)
        let rating = srsService.ratingForCorrectness(wasCorrect: wasCorrect)
        _ = srsService.review(progress: progress, rating: rating)
        try? modelContext.save()
    }

    private func fetchOrCreateProgress(for wordID: String) -> WordProgress {
        let descriptor = FetchDescriptor<WordProgress>(
            predicate: #Predicate { $0.wordId == wordID }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let progress = WordProgress(wordId: wordID)
        modelContext.insert(progress)
        return progress
    }

    private func fetchAllProgress() -> [WordProgress] {
        let descriptor = FetchDescriptor<WordProgress>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
