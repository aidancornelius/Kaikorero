//
//  BilingualLabel.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI

struct BilingualLabel: View {
    let teReo: String
    let english: String
    var teReoFont: Font = .title2
    var englishFont: Font = .subheadline
    var alignment: HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(teReo)
                .font(teReoFont)
                .fontWeight(.bold)
            Text(english)
                .font(englishFont)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    BilingualLabel(teReo: "Kupu", english: "Words")
        .padding()
}
