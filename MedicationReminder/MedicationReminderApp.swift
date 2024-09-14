//
//  Medication_ReminderApp.swift
//  Medication Reminder
//
//  Created by Udacity
//

import SwiftUI
import SwiftData

@main
struct MedicationReminderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Medication.self,
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
            MedicationDashboard()
        }
        .modelContainer(sharedModelContainer)
    }
}

