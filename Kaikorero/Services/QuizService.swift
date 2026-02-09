//
//  QuizService.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

enum QuizType: Int, CaseIterable, Codable, Sendable, Identifiable {
    case multipleChoice = 0
    case reverseChoice = 1
    case trueFalse = 2
    case listenChoose = 3

    var id: Int { rawValue }

    var teReo: String {
        switch self {
        case .multipleChoice: "Kōwhiri Maha"
        case .reverseChoice: "Kōwhiri Whakamuri"
        case .trueFalse: "Āe, Kāo"
        case .listenChoose: "Whakarongo, Kōwhiri"
        }
    }

    var english: String {
        switch self {
        case .multipleChoice: "Multiple Choice"
        case .reverseChoice: "Reverse Choice"
        case .trueFalse: "True or False"
        case .listenChoose: "Listen & Choose"
        }
    }

    var iconName: String {
        switch self {
        case .multipleChoice: "list.bullet"
        case .reverseChoice: "arrow.left.arrow.right"
        case .trueFalse: "checkmark.circle"
        case .listenChoose: "ear"
        }
    }
}

struct QuizQuestion: Identifiable, Sendable {
    let id = UUID()
    let word: WordEntry
    let type: QuizType
    let options: [String]
    let correctAnswerIndex: Int
    let displayText: String // The prompt shown to the user
    let isTrueFalsePairCorrect: Bool? // Only for trueFalse type
}

@Observable
final class QuizService {
    private let wordDataService: WordDataService

    init(wordDataService: WordDataService) {
        self.wordDataService = wordDataService
    }

    func generateQuiz(
        words: [WordEntry],
        types: Set<QuizType>,
        questionCount: Int
    ) -> [QuizQuestion] {
        guard !words.isEmpty, !types.isEmpty else { return [] }

        let availableTypes = types.filter { type in
            if type == .listenChoose {
                return words.contains { $0.audioFileName != nil }
            }
            return true
        }
        guard !availableTypes.isEmpty else { return [] }

        let sortedTypes = availableTypes.sorted { $0.rawValue < $1.rawValue }

        var questions: [QuizQuestion] = []
        let shuffledWords = words.shuffled()

        for i in 0..<min(questionCount, shuffledWords.count) {
            let word = shuffledWords[i]
            let type = sortedTypes[i % sortedTypes.count]

            if let question = generateQuestion(word: word, type: type) {
                questions.append(question)
            }
        }

        return questions.shuffled()
    }

    private func generateQuestion(word: WordEntry, type: QuizType) -> QuizQuestion? {
        switch type {
        case .multipleChoice:
            return generateMultipleChoice(word: word)
        case .reverseChoice:
            return generateReverseChoice(word: word)
        case .trueFalse:
            return generateTrueFalse(word: word)
        case .listenChoose:
            return generateListenChoose(word: word)
        }
    }

    private func generateMultipleChoice(word: WordEntry) -> QuizQuestion {
        let distractors = wordDataService.distractors(for: word, count: 3)
        var options = distractors.map(\.english) + [word.english]
        options.shuffle()
        let correctIndex = options.firstIndex(of: word.english) ?? 0

        return QuizQuestion(
            word: word,
            type: .multipleChoice,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: word.teReo,
            isTrueFalsePairCorrect: nil
        )
    }

    private func generateReverseChoice(word: WordEntry) -> QuizQuestion {
        let distractors = wordDataService.distractors(for: word, count: 3)
        var options = distractors.map(\.teReo) + [word.teReo]
        options.shuffle()
        let correctIndex = options.firstIndex(of: word.teReo) ?? 0

        return QuizQuestion(
            word: word,
            type: .reverseChoice,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: word.english,
            isTrueFalsePairCorrect: nil
        )
    }

    private func generateTrueFalse(word: WordEntry) -> QuizQuestion {
        let isCorrectPair = Bool.random()

        let displayedTranslation: String
        if isCorrectPair {
            displayedTranslation = word.english
        } else {
            let distractors = wordDataService.distractors(for: word, count: 1)
            displayedTranslation = distractors.first?.english ?? word.english
        }

        let options = ["Āe", "Kāo"]
        let correctIndex = isCorrectPair ? 0 : 1

        return QuizQuestion(
            word: word,
            type: .trueFalse,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: "\(word.teReo) = \(displayedTranslation)",
            isTrueFalsePairCorrect: isCorrectPair
        )
    }

    private func generateListenChoose(word: WordEntry) -> QuizQuestion? {
        guard word.audioFileName != nil else { return nil }

        let distractors = wordDataService.distractors(for: word, count: 3)
        var options = distractors.map(\.english) + [word.english]
        options.shuffle()
        let correctIndex = options.firstIndex(of: word.english) ?? 0

        return QuizQuestion(
            word: word,
            type: .listenChoose,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: "🔊",
            isTrueFalsePairCorrect: nil
        )
    }
}
