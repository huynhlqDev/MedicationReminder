//
//  medication.swift
//  Medication Reminder
//
//  Created by Udacity
//
import Foundation
import SwiftData

// Medication Model

@Model
final class Medication {
    @Attribute(.unique) var name: String = ""
    var dosage: String = ""
    var time: TimeInterval
    @Attribute var isReminderSet: Bool = false
    var reminderInterval: TimeInterval?

    init(name: String, dosage: String, time: TimeInterval, isReminderSet: Bool = false, reminderInterval: TimeInterval? = nil) {
        self.name = name
        self.dosage = dosage
        self.time = time
        self.isReminderSet = isReminderSet
        self.reminderInterval = reminderInterval
    }
    
}
extension Medication {
    static var example: Medication {
        Medication(name: "Example Medicine", dosage: "100mg", time: Date().timeIntervalSinceReferenceDate)
    }
}


