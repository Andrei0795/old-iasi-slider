//
//  Old_Iasi_SliderApp.swift
//  Old Iasi Slider
//
//  Created by Andrei Ionescu on 27.03.2025.
//

import SwiftUI
import SwiftData

@main
struct Old_Iasi_SliderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
