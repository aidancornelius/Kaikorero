//
//  MaoriKeyboardPrompt.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

/// A helper view that guides users to enable the Māori keyboard on iOS,
/// which includes macron (tohutō) support for vowels.
struct MaoriKeyboardPrompt: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Papapātuhi Māori")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Māori Keyboard")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Text("iOS has a built-in te reo Māori keyboard that makes it easy to type macrons (tohutō). Long-press a vowel to access ā, ē, ī, ō, ū.")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 16) {
                        instructionStep(number: 1, text: "Open the Settings app")
                        instructionStep(number: 2, text: "Go to General → Keyboard → Keyboards")
                        instructionStep(number: 3, text: "Tap \"Add New Keyboard…\"")
                        instructionStep(number: 4, text: "Search for \"Māori\" and select it")
                        instructionStep(number: 5, text: "When typing, hold the globe 🌐 key to switch keyboards")
                    }

                    Button {
                        #if os(iOS)
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                        #endif
                    } label: {
                        Label("Open Settings", systemImage: "gear")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Text("With the Māori keyboard active, vowels with macrons appear directly — no long-press needed.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func instructionStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Color.accentColor)
                .clipShape(Circle())

            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    MaoriKeyboardPrompt()
}
