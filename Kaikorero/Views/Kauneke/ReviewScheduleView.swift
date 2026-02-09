//
//  ReviewScheduleView.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct ReviewScheduleView: View {
    let progressViewModel: ProgressViewModel

    var body: some View {
        List {
            if progressViewModel.upcomingReviews.isEmpty {
                ContentUnavailableView(
                    "Kāore he arotake",
                    systemImage: "calendar.badge.checkmark",
                    description: Text("No upcoming reviews. Complete some quizzes to schedule reviews.")
                )
            } else {
                ForEach(Array(progressViewModel.upcomingReviews.enumerated()), id: \.offset) { _, review in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(review.date.shortDate)
                                .font(.headline)
                            Text(review.date.relativeDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(review.count)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("kupu")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if review.date.isToday {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Ngā Arotake")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                BilingualLabel(
                    teReo: "Ngā Arotake",
                    english: "Review Schedule",
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
