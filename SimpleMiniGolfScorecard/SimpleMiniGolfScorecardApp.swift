//
//  SimpleMiniGolfScorecardApp.swift
//  SimpleMiniGolfScorecard
//
//  Created by William Castellano on 11/13/25.
//

import SwiftUI
import SwiftData

@main
struct SimpleMiniGolfScorecardApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Player.self,
            Course.self,
            Game.self,
            Score.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed Popstroke courses on first launch
            if SeedData.shouldSeedData(modelContext: container.mainContext) {
                SeedData.createPopstrokeCourses(modelContext: container.mainContext)
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
