//
//  AcknowledgementsView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct AcknowledgementsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "text.book.closed.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.accentColor)

                        Text("Kaikōrero")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Te reo Māori vocabulary learning")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("v1.0.0")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("He taonga te reo Māori — te reo Māori is a treasure. This app was built with deep respect for te reo Māori me ōna tikanga (the Māori language and its customs).")
                            .font(.subheadline)

                        Text("We acknowledge the mana of te reo Māori as an official language of Aotearoa New Zealand, and the ongoing work of kaiako, kaumātua, and communities who nurture and revitalise the language.")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                } header: {
                    BilingualLabel(
                        teReo: "Te Reo Māori",
                        english: "The Māori Language",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }

                Section {
                    acknowledgementRow(
                        title: "A Dictionary of the Maori Language",
                        subtitle: "Herbert W. Williams",
                        detail: "This foundational dictionary of te reo Māori has informed generations of learners and scholars.",
                        license: nil
                    )

                    acknowledgementRow(
                        title: "Te Aka Māori Dictionary",
                        subtitle: "John C. Moorfield",
                        detail: "An invaluable online resource for te reo Māori learners. We encourage all learners to visit teara.govt.nz/mi/te-aka.",
                        license: nil
                    )
                } header: {
                    BilingualLabel(
                        teReo: "Ngā Papakupu",
                        english: "References",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }

                Section {
                    acknowledgementRow(
                        title: "Māori TTS",
                        subtitle: "KingsleyEng on HuggingFace",
                        detail: "Text-to-speech model used to generate pronunciation audio for all words.",
                        license: nil
                    )
                } header: {
                    BilingualLabel(
                        teReo: "Te Reo Irirangi",
                        english: "Audio",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }

                Section {
                    acknowledgementRow(
                        title: "swift-fsrs",
                        subtitle: "4rays",
                        detail: "FSRS v5 spaced repetition algorithm implementation in Swift, powering the review scheduling system.",
                        license: "MIT"
                    )
                } header: {
                    BilingualLabel(
                        teReo: "Ngā Rauemi Hangarau",
                        english: "Technology",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kaikōrero is open source software, licensed under the Mozilla Public License 2.0.")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                } header: {
                    BilingualLabel(
                        teReo: "Raihana",
                        english: "Licensing",
                        teReoFont: .subheadline,
                        englishFont: .caption2
                    )
                }
            }
            .navigationTitle("Mōhiohio")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Mōhiohio",
                        english: "About",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
        }
    }

    private func acknowledgementRow(title: String, subtitle: String, detail: String, license: String?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)

            if let license {
                Text(license)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
