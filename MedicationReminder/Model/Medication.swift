//
//  medication.swift
//  Medication Reminder
//
//  Created by Udacity
//
import Foundation
import SwiftData

enum ReminderDay: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"

    var title: String {
        switch self {
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        case .sunday: "Sun"
        }
    }
}

// Medication Model
@Model
final class Medication {
    var id: UUID
    @Attribute(.unique) 
    var name: String = ""
    var dosage: String = ""
    var time: TimeInterval
    @Attribute
    var isReminderSet: Bool = false
    var reminderInterval: TimeInterval?
    var reminderDays: [ReminderDay]

    init(name: String, 
         dosage: String,
         time: TimeInterval,
         isReminderSet: Bool = false,
         reminderInterval: TimeInterval? = nil,
         reminderDays: [ReminderDay]
    ) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.time = time
        self.isReminderSet = isReminderSet
        self.reminderInterval = reminderInterval
        self.reminderDays = reminderDays
    }

    func update(
        name: String? = nil,
        dosage: String? = nil,
        time: TimeInterval? = nil,
        isReminderSet: Bool? = nil,
        reminderInterval: TimeInterval? = nil,
        reminderDays: [ReminderDay]? = nil
    ) {
        if let name {
            self.name = name
        }
        if let dosage {
            self.dosage = dosage
        }
        if let time {
            self.time = time
        }
        if let isReminderSet {
            self.isReminderSet = isReminderSet
        }
        if let reminderInterval {
            self.reminderInterval = reminderInterval
        }
        if let reminderDays {
            self.reminderDays = reminderDays
        }
    }

}

extension Medication {
    static var example: Medication {
        Medication(name: "Example Medicine", dosage: "100mg", time: Date().timeIntervalSinceReferenceDate, reminderDays: [])
    }
}


