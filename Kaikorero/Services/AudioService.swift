//
//  AudioService.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import AVFoundation
import Foundation

@Observable
@MainActor
final class AudioService: NSObject, AVAudioPlayerDelegate {
    var isPlaying = false

    private var audioPlayer: AVAudioPlayer?
    private var sessionConfigured = false

    func play(fileName: String) {
        // Stop any current playback
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false

        let name = (fileName as NSString).deletingPathExtension
        let ext = (fileName as NSString).pathExtension

        guard let url = Bundle.main.url(forResource: name, withExtension: ext.isEmpty ? "m4a" : ext) else {
            print("[AudioService] File not found in bundle: \(fileName)")
            return
        }

        do {
            #if os(iOS)
            if !sessionConfigured {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
                sessionConfigured = true
            }
            #endif

            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.play()
            audioPlayer = player
            isPlaying = true
        } catch {
            print("[AudioService] Playback error: \(error.localizedDescription)")
            isPlaying = false
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.isPlaying = false
        }
    }
}
