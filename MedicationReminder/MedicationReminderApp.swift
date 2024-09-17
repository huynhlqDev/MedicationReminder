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

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            MedicationDashboard()
        }
        .modelContainer(sharedModelContainer)
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
}

// MARK: ShapeStyle extension
extension ShapeStyle where Self == Color {
    public static var dynamicTextColor: Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        })
    }
}
