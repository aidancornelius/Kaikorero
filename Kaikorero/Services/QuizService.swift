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
    case whakatauki = 4
    case listenSentence = 5

    var id: Int { rawValue }

    var teReo: String {
        switch self {
        case .multipleChoice: "Kōwhiri Maha"
        case .reverseChoice: "Kōwhiri Whakamuri"
        case .trueFalse: "Āe, Kāo"
        case .listenChoose: "Whakarongo, Kōwhiri"
        case .whakatauki: "Whakataukī"
        case .listenSentence: "Whakarongo Rerenga"
        }
    }

    var english: String {
        switch self {
        case .multipleChoice: "Multiple Choice"
        case .reverseChoice: "Reverse Choice"
        case .trueFalse: "True or False"
        case .listenChoose: "Listen & Choose"
        case .whakatauki: "Proverbs"
        case .listenSentence: "Listen to Sentence"
        }
    }

    var iconName: String {
        switch self {
        case .multipleChoice: "list.bullet"
        case .reverseChoice: "arrow.left.arrow.right"
        case .trueFalse: "checkmark.circle"
        case .listenChoose: "ear"
        case .whakatauki: "text.quote"
        case .listenSentence: "waveform.and.mic"
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
    let subtitle: String? // English translation for whakatauki, sentence text for listenSentence
    let sentenceAudioFileName: String? // For listenSentence type
    let promptAudioFileName: String? // Audio to play when question appears (e.g. blanked whakatauki)
    let revealAudioFileName: String? // Audio to play after answering (e.g. full whakatauki)

    init(
        word: WordEntry,
        type: QuizType,
        options: [String],
        correctAnswerIndex: Int,
        displayText: String,
        isTrueFalsePairCorrect: Bool? = nil,
        subtitle: String? = nil,
        sentenceAudioFileName: String? = nil,
        promptAudioFileName: String? = nil,
        revealAudioFileName: String? = nil
    ) {
        self.word = word
        self.type = type
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.displayText = displayText
        self.isTrueFalsePairCorrect = isTrueFalsePairCorrect
        self.subtitle = subtitle
        self.sentenceAudioFileName = sentenceAudioFileName
        self.promptAudioFileName = promptAudioFileName
        self.revealAudioFileName = revealAudioFileName
    }
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
            switch type {
            case .listenChoose:
                return words.contains { $0.audioFileName != nil }
            case .whakatauki:
                return !wordDataService.whakatauki.isEmpty
            case .listenSentence:
                return words.contains { $0.sentenceAudioFileName != nil && $0.exampleSentence != nil }
            default:
                return true
            }
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
        case .whakatauki:
            return generateWhakatauki(word: word)
        case .listenSentence:
            return generateListenSentence(word: word)
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
            displayText: "🔊"
        )
    }

    private func generateWhakatauki(word: WordEntry) -> QuizQuestion? {
        let proverb: Whakatauki
        let targetWord: WordEntry

        if let p = wordDataService.whakatauki(for: word.id) {
            // This word has a matching proverb — use it directly
            proverb = p
            targetWord = word
        } else if let p = wordDataService.whakatauki.randomElement(),
                  let tw = wordDataService.word(for: p.targetWordId) {
            // Pick a random proverb and quiz on its target word
            proverb = p
            targetWord = tw
        } else {
            return generateMultipleChoice(word: word)
        }

        let distractors = wordDataService.distractors(for: targetWord, count: 3)
        var options = distractors.map(\.teReo) + [targetWord.teReo]
        options.shuffle()
        let correctIndex = options.firstIndex(of: targetWord.teReo) ?? 0

        return QuizQuestion(
            word: targetWord,
            type: .whakatauki,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: proverb.blankedText,
            subtitle: proverb.english,
            promptAudioFileName: proverb.blankedAudioFileName,
            revealAudioFileName: proverb.fullAudioFileName
        )
    }

    private func generateListenSentence(word: WordEntry) -> QuizQuestion? {
        guard let sentenceAudio = word.sentenceAudioFileName,
              let sentence = word.exampleSentence else {
            // Fall back to multiple choice if no sentence audio
            return generateMultipleChoice(word: word)
        }

        let distractors = wordDataService.distractors(for: word, count: 3)
        var options = distractors.map(\.teReo) + [word.teReo]
        options.shuffle()
        let correctIndex = options.firstIndex(of: word.teReo) ?? 0

        return QuizQuestion(
            word: word,
            type: .listenSentence,
            options: options,
            correctAnswerIndex: correctIndex,
            displayText: "🔊",
            subtitle: "\(sentence)\n\(word.exampleTranslation ?? "")",
            sentenceAudioFileName: sentenceAudio
        )
    }
}
