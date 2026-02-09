//
//  QuizServiceTests.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Testing
import Foundation
@testable import Kaikorero

@Suite("QuizService Tests")
struct QuizServiceTests {

    private func makeService() -> (QuizService, WordDataService) {
        let wordDataService = WordDataService()
        let quizService = QuizService(wordDataService: wordDataService)
        return (quizService, wordDataService)
    }

    @Test("Generate multiple choice questions")
    func generateMultipleChoice() {
        let (quizService, wordDataService) = makeService()
        let words = Array(wordDataService.words.prefix(10))

        let questions = quizService.generateQuiz(
            words: words,
            types: [.multipleChoice],
            questionCount: 5
        )

        #expect(!questions.isEmpty, "Should generate questions")
        #expect(questions.count <= 5, "Should not exceed requested count")

        for question in questions {
            #expect(question.options.count == 4, "MC should have 4 options")
            #expect(question.correctAnswerIndex >= 0 && question.correctAnswerIndex < 4)
            #expect(question.options[question.correctAnswerIndex] == question.word.english)
        }
    }

    @Test("Generate reverse choice questions")
    func generateReverseChoice() {
        let (quizService, wordDataService) = makeService()
        let words = Array(wordDataService.words.prefix(10))

        let questions = quizService.generateQuiz(
            words: words,
            types: [.reverseChoice],
            questionCount: 5
        )

        #expect(!questions.isEmpty)
        for question in questions {
            #expect(question.options.count == 4)
            #expect(question.options[question.correctAnswerIndex] == question.word.teReo)
        }
    }

    @Test("Generate true/false questions")
    func generateTrueFalse() {
        let (quizService, wordDataService) = makeService()
        let words = Array(wordDataService.words.prefix(10))

        let questions = quizService.generateQuiz(
            words: words,
            types: [.trueFalse],
            questionCount: 5
        )

        #expect(!questions.isEmpty)
        for question in questions {
            #expect(question.options.count == 2)
            #expect(question.options == ["Āe", "Kāo"])
            #expect(question.isTrueFalsePairCorrect != nil)
        }
    }

    @Test("Mixed quiz types")
    func mixedQuizTypes() {
        let (quizService, wordDataService) = makeService()
        let words = Array(wordDataService.words.prefix(10))

        let questions = quizService.generateQuiz(
            words: words,
            types: [.multipleChoice, .reverseChoice, .trueFalse],
            questionCount: 9
        )

        #expect(!questions.isEmpty)
        let types = Set(questions.map(\.type))
        #expect(types.count > 1, "Should have multiple question types")
    }

    @Test("Empty words returns empty quiz")
    func emptyWords() {
        let (quizService, _) = makeService()

        let questions = quizService.generateQuiz(
            words: [],
            types: [.multipleChoice],
            questionCount: 5
        )

        #expect(questions.isEmpty)
    }

    @Test("Question count is limited by available words")
    func questionCountLimited() {
        let (quizService, wordDataService) = makeService()
        let words = Array(wordDataService.words.prefix(3))

        let questions = quizService.generateQuiz(
            words: words,
            types: [.multipleChoice],
            questionCount: 10
        )

        #expect(questions.count <= 3, "Cannot generate more questions than words")
    }
}
