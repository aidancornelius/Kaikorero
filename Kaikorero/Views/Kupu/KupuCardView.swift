//
//  KupuCardView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct KupuCardView: View {
    let word: WordEntry
    let audioViewModel: AudioViewModel
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            // Front - Te Reo
            cardFace(isBack: false) {
                VStack(spacing: 16) {
                    Text(word.teReo)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(word.partOfSpeech)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.lowercase)

                    if word.audioFileName != nil {
                        AudioPlayButton(fileName: word.audioFileName, audioViewModel: audioViewModel)
                    }

                    Text("Tap to reveal")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .opacity(isFlipped ? 0 : 1)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back - English
            cardFace(isBack: true) {
                VStack(spacing: 12) {
                    Text(word.english)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    if !word.alternativeTranslations.isEmpty {
                        Text(word.alternativeTranslations.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if let sentence = word.exampleSentence {
                        Divider()
                        VStack(spacing: 4) {
                            Text(sentence)
                                .font(.body)
                                .italic()
                            if let translation = word.exampleTranslation {
                                Text(translation)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .multilineTextAlignment(.center)
                    }
                }
            }
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                isFlipped.toggle()
            }
        }
        .accessibilityLabel("\(word.teReo), \(word.english)")
        .accessibilityHint("Double tap to flip card")
    }

    private func cardFace<Content: View>(isBack: Bool, @ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}
