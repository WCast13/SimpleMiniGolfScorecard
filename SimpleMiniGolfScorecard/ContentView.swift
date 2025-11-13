//
//  ContentView.swift
//  SimpleMiniGolfScorecard
//
//  Created by William Castellano on 11/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            GamesListView()
                .tabItem {
                    Label("Games", systemImage: "sportscourt.fill")
                }

            CoursesListView()
                .tabItem {
                    Label("Courses", systemImage: "flag.fill")
                }

            PlayersListView()
                .tabItem {
                    Label("Players", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Game.self, Course.self, Player.self, Score.self], inMemory: true)
}
