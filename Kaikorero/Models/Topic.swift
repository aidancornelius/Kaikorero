//
//  Topic.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Foundation
import SwiftUI

struct Topic: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let teReo: String
    let english: String
    let iconName: String
    let sortOrder: Int

    var color: Color {
        switch id {
        case "mihimihi": .orange
        case "whanau": .pink
        case "tinana": .red
        case "taiao": .green
        case "kai": .brown
        case "tae": .purple
        case "tau": .indigo
        case "wa": .cyan
        case "huarere": .teal
        case "kararehe": .mint
        case "mahi": .blue
        case "kare-a-roto": .pink
        case "wahi": .gray
        case "kakahu": .purple
        case "kainga": .orange
        case "wetereo": .indigo
        default: .accentColor
        }
    }
}
