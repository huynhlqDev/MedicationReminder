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

// MARK: UIScreen extension
extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

// MARK: ShapeStyle extension
extension ShapeStyle where Self == Color {
    public static var dynamicTextColor: Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        })
    }

    public static var appStyle: Color {
        return Color(red: 50/255, green: 170/255, blue: 255/255, opacity: 1)
    }

}

extension UIColor {
    public static var appColor: UIColor {
        return UIColor(Color(red: 78/255, green: 200/255, blue: 255/255, opacity: 1))
    }
}

// MARK: Date extensison
extension Date {
    func getDateWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/mm/dd"
        return dateFormatter.string(from: self)
    }

    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: self)
    }

    func getDayShort() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }

    func getDayNumber() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }

    func getWeek() -> [Date] {
        let calendar = Calendar.current

        let dayOfWeek = calendar.component(.weekday, from: self)
        let range = calendar.range(of: .day, in: .month, for: self)!
        let daysMonth = (range.lowerBound ..< range.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: self) }
        return daysMonth
    }

    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
