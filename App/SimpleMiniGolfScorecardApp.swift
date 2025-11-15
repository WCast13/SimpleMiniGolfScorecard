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

        // Enable CloudKit sync with automatic cloud database
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed Popstroke courses on first launch
            if SeedData.shouldSeedData(modelContext: container.mainContext) {
                SeedData.createPopstrokeCourses(modelContext: container.mainContext)
            }

            return container
        } catch let error as NSError {
            // If CloudKit initialization fails, provide more context
            print("❌ ModelContainer Error: \(error)")
            print("Error Domain: \(error.domain)")
            print("Error Code: \(error.code)")
            print("Error Info: \(error.userInfo)")

            // Try to create container without CloudKit as fallback
            do {
                print("⚠️ Attempting to create container without CloudKit...")
                let fallbackConfig = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: false,
                    cloudKitDatabase: .none
                )
                let container = try ModelContainer(for: schema, configurations: [fallbackConfig])
                print("✅ Successfully created container without CloudKit")

                // Seed data if needed
                if SeedData.shouldSeedData(modelContext: container.mainContext) {
                    SeedData.createPopstrokeCourses(modelContext: container.mainContext)
                }

                return container
            } catch {
                fatalError("Could not create ModelContainer even without CloudKit: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
