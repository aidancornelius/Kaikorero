//
//  AudioPlayButton.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct AudioPlayButton: View {
    let fileName: String?
    let audioViewModel: AudioViewModel

    var body: some View {
        Button {
            if let fileName {
                audioViewModel.play(fileName: fileName)
            }
        } label: {
            Image(systemName: audioViewModel.isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .symbolEffect(.variableColor.iterative, isActive: audioViewModel.isPlaying)
        }
        .disabled(fileName == nil)
        .opacity(fileName == nil ? 0.3 : 1)
        .accessibilityLabel("Play pronunciation")
    }
}
