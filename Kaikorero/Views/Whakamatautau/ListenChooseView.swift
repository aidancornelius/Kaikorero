//
//  ListenChooseView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

/// Listen & Choose quiz type — plays audio, user picks the correct translation.
struct ListenChooseView: View {
    let audioFileName: String
    let options: [String]
    let correctIndex: Int
    let audioViewModel: AudioViewModel
    var onAnswer: ((Bool) -> Void)?

    @State private var selectedIndex: Int?
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Text("Whakarongo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Button {
                    audioViewModel.play(fileName: audioFileName)
                } label: {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 48))
                        .symbolEffect(.variableColor.iterative, isActive: audioViewModel.isPlaying)
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 100, height: 100)
                        .background(.fill.tertiary)
                        .clipShape(Circle())
                }

                Text("Tap to listen")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            VStack(spacing: 12) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard !showResult else { return }
                        selectedIndex = index
                        showResult = true
                        onAnswer?(index == correctIndex)
                    } label: {
                        HStack {
                            Text(option)
                                .font(.body)

                            Spacer()

                            if showResult {
                                if index == correctIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if index == selectedIndex {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding()
                        .background(optionBackground(index: index))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .tint(.primary)
                }
            }
            .padding(.horizontal)
        }
    }

    private func optionBackground(index: Int) -> some ShapeStyle {
        if showResult {
            if index == correctIndex {
                return AnyShapeStyle(.green.opacity(0.15))
            } else if index == selectedIndex {
                return AnyShapeStyle(.red.opacity(0.15))
            }
        }
        return AnyShapeStyle(.fill.tertiary)
    }
}
