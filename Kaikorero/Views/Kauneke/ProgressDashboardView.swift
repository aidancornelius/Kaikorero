//
//  ProgressDashboardView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct ProgressDashboardView: View {
    let progressViewModel: ProgressViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        statCard(
                            teReo: "Kupu",
                            english: "Words Learned",
                            value: "\(progressViewModel.totalWordsLearned)",
                            icon: "text.book.closed.fill",
                            color: .blue
                        )
                        statCard(
                            teReo: "Akoranga",
                            english: "Total Reviews",
                            value: "\(progressViewModel.totalReviews)",
                            icon: "arrow.clockwise",
                            color: .purple
                        )
                        statCard(
                            teReo: "Tika",
                            english: "Accuracy",
                            value: "\(Int(progressViewModel.overallAccuracy * 100))%",
                            icon: "target",
                            color: .green
                        )
                        statCard(
                            teReo: "Rārangi",
                            english: "Day Streak",
                            value: "\(progressViewModel.currentStreak)",
                            icon: "flame.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)

                    // Words due for review
                    if progressViewModel.wordsToReview > 0 {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Kupu hei arotake")
                                    .font(.headline)
                                Text("Words to review")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("\(progressViewModel.wordsToReview)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                        }
                        .padding()
                        .background(.fill.quaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }

                    // Upcoming reviews
                    if !progressViewModel.upcomingReviews.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            BilingualLabel(
                                teReo: "Ngā Arotake",
                                english: "Upcoming Reviews",
                                teReoFont: .headline,
                                englishFont: .caption
                            )

                            ForEach(Array(progressViewModel.upcomingReviews.enumerated()), id: \.offset) { _, review in
                                HStack {
                                    Text(review.date.shortDate)
                                        .font(.subheadline)

                                    Spacer()

                                    Text("\(review.count) kupu")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    if review.date.isToday {
                                        Text("Āianei")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(.orange.opacity(0.15))
                                            .foregroundStyle(.orange)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(.fill.quaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Kauneke")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BilingualLabel(
                        teReo: "Kauneke",
                        english: "Progress",
                        teReoFont: .headline,
                        englishFont: .caption,
                        alignment: .center
                    )
                }
            }
            .onAppear {
                progressViewModel.refresh()
            }
        }
    }

    private func statCard(teReo: String, english: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 2) {
                Text(teReo)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(english)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.fill.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(english): \(value)")
    }
}
