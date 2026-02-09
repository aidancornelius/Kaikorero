//
//  KaikoreroApp.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import SwiftUI
import SwiftData

@main
struct KaikoreroApp: App {
    let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            WordProgress.self,
            QuizResult.self,
            LearnerSettings.self,
        ])
        let config = ModelConfiguration(
            "Kaikorero",
            schema: schema,
            cloudKitDatabase: .private("iCloud.com.cornelius-bell.kaikorero")
        )
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
