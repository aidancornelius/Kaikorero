//
//  AudioViewModel.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation

@Observable
@MainActor
final class AudioViewModel {
    private let audioService: AudioService

    var isPlaying: Bool {
        audioService.isPlaying
    }

    init(audioService: AudioService) {
        self.audioService = audioService
    }

    func play(fileName: String) {
        audioService.play(fileName: fileName)
    }

    func stop() {
        audioService.stop()
    }
}
