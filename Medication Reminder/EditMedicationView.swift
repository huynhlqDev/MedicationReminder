//
//  EditMedicationView.swift
//  Medication Reminder
//
//  Created by V Scarlata on 4/11/24.
//

import SwiftUI
import SwiftData

struct EditMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var dosage: String
    @State private var time: Date
    @State private var isReminderSet: Bool
    @State private var reminderInterval: TimeInterval?

    init(medication: Medication) {
        self._name = State(initialValue: medication.name)
        self._dosage = State(initialValue: medication.dosage)
        self._time = State(initialValue: Date(timeIntervalSinceReferenceDate: medication.time))
        self._isReminderSet = State(initialValue: medication.isReminderSet)
        self._reminderInterval = State(initialValue: medication.reminderInterval)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Toggle("Reminder", isOn: $isReminderSet)

                if isReminderSet {
                    Picker("Reminder Interval (Hours)", selection: $reminderInterval) {
                        ForEach(0..<25) { hour in
                            Text("\(hour)") .tag(Double(hour * 3600))
                        }
                    }
                }

                Button("Save Changes") {
                    saveChanges()
                }
            }
        }
        .navigationTitle("Edit Medication")
    }

    private func saveChanges() {
        if let existingMedication = try? modelContext.existingObject(medication) {
            existingMedication.name = name
            existingMedication.dosage = dosage
            existingMedication.time = time.timeIntervalSinceReferenceDate
            existingMedication.isReminderSet = isReminderSet
            existingMedication.reminderInterval = reminderInterval

            try? modelContext.save()
            dismiss()
        } else {
            // Handle error if medication not found (unlikely)
        }
    }
}
