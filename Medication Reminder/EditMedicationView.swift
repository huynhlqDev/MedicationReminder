//
//  EditMedicationView.swift
//  Medication Reminder
//
//  Created by Udacity

import SwiftUI
import SwiftData

// a view to edit medication

struct EditMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss // For dismissing the view

    let medication: Medication? // Can be nil when adding new

    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var time: Date = Date()  // Notice: Using Date for time editing
    @State private var isReminderSet: Bool = false

    init(medication: Medication?) {
        self.medication = medication
        // Initialize state variables based on existing Medication if editing
        if let medication = medication {
            _name = State(initialValue: medication.name)
            _dosage = State(initialValue: medication.dosage)
            _time = State(initialValue: Date(timeIntervalSinceReferenceDate: medication.time))
            _isReminderSet = State(initialValue: medication.isReminderSet)
        }
    }

    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                Toggle("Reminder", isOn: $isReminderSet)
            }
        }
        .navigationTitle(medication == nil ? "Add Medication" : "Edit Medication")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) { saveButton }
            ToolbarItem(placement: .cancellationAction) { cancelButton }
        }
    }

    private var saveButton: some View {
        Button("Save") {
            saveChanges()
            dismiss()
        }
    }

    private var cancelButton: some View {
        Button("Cancel", role: .cancel) {
            dismiss()
        }
    }

    private func saveChanges() {
        if let existingMedication = medication {
           // Update existing medication
            existingMedication.name = name
            existingMedication.dosage = dosage
            existingMedication.time = time.timeIntervalSinceReferenceDate
            existingMedication.isReminderSet = isReminderSet
        } else {
            // Create a new medication
            let newMedication = Medication(name: name, dosage: dosage, time: time.timeIntervalSinceReferenceDate, isReminderSet: isReminderSet)
            modelContext.insert(newMedication)
        }

        // Note: Consider using try? modelContext.save() for error handling
    }
}

#Preview {
    EditMedicationView(medication: Medication.example)
        .modelContainer(for: Medication.self, inMemory: true)
}
