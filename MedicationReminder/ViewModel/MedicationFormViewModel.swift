//
//  MedicationFormViewModel.swift
//  MedicationReminder
//
//  Created by huynh on 16/9/24.
//
import SwiftUI
import SwiftData

class MedicationFormViewModel: ObservableObject {
    @Published var medicationName: String
    @Published var dosage: String
    @Published var remainderTime: Date
    @Published var selectedDays: [ReminderDay]
    @Published var isReminderSet: Bool
    @Published var title: String

    var medication: Medication?
    private var context: ModelContext?

    var repeatDescription: String {
        if selectedDays.count == 7 {
            return "Every day"
        } else {
            return selectedDays.map {
                $0.rawValue
            }.joined(separator: ",")
        }
    }

    init(medication: Medication? = nil) {
        self.medication = medication
        self.medicationName = medication?.name ?? ""
        self.dosage = medication?.dosage ?? ""
        self.remainderTime = Date(timeIntervalSinceReferenceDate: medication?.time ?? Date().timeIntervalSinceReferenceDate)
        self.selectedDays = medication?.reminderDays ?? ReminderDay.allCases
        self.title = medication != nil ? "Edit Medication" : "Create Medication"
        self.isReminderSet = medication?.isReminderSet ?? false
    }

    func setContext(context: ModelContext) {
        self.context = context

    }

    func saveMedication() {
        do {
            guard let context else { return }
            if let medication = medication {
                // Edit existing medication
                medication.update(name: medicationName,
                                  dosage: dosage,
                                  time: remainderTime.timeIntervalSinceReferenceDate,
                                  isReminderSet: isReminderSet,
                                  reminderDays: selectedDays)
                scheduleNotificationIfNeed(medicationReminder: medication)
            } else {
                // Create new medication
                let newMedication = Medication(name: medicationName,
                                               dosage: dosage,
                                               time: remainderTime.timeIntervalSinceReferenceDate,
                                               reminderDays:
                                                selectedDays)
                context.insert(newMedication)
                scheduleNotificationIfNeed(medicationReminder: newMedication)
            }

            try context.save()
        } catch {
            print(#function + error.localizedDescription)
        }
    }

    func deleteMedication() {
        do {
            guard let context else { return }
            guard let medication else { return }
            context.delete(medication)
            try context.save()
        } catch {
            print(#function + error.localizedDescription)
        }
    }

    func toggleDaySelection(_ day: ReminderDay) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }

    func scheduleNotificationIfNeed(medicationReminder: Medication) {
        guard medicationReminder.isReminderSet else { return }

        let futureDate = Date(timeIntervalSinceReferenceDate: medicationReminder.time)
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "You need take \(String(describing: medication?.dosage ?? ""))."
        content.sound = .default

        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [medicationReminder.id.uuidString])

        medicationReminder.reminderDays.forEach { reminderDay in
            var components = Calendar.current.dateComponents([.hour, .minute], from: futureDate)
            components.weekday = reminderDay.weekday

            addNotification(
                identifier: medicationReminder.id.uuidString,
                components: components,
                content: content
            )
        }
    }

    private func addNotification(
        identifier: String,
        components: DateComponents,
        content: UNMutableNotificationContent
    ) {
        var dateComponent = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
        dateComponent.weekday = components.weekday
        dateComponent.hour = components.hour
        dateComponent.minute = components.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent,
                                                    repeats: true)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

}

