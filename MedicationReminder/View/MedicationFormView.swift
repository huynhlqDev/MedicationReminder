//
//  MedicationFormView.swift
//  MedicationReminder
//
//  Created by huynh on 16/9/24.
//
import SwiftData
import SwiftUI

struct MedicationFormView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: MedicationFormViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isRepeatPickerPresented: Bool = false
    @State private var showAlert: Bool = false

    init(medication: Medication? = nil) {
        viewModel = MedicationFormViewModel(medication: medication)
    }

    /// body
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.medicationName)
                        .font(.headline)
                    TextField("Dosage", text: $viewModel.dosage)
                    repeatButton
                    DatePicker("Time",
                               selection: $viewModel.remainderTime,
                               displayedComponents: .hourAndMinute)
                    Toggle("Reminder", isOn: $viewModel.isReminderSet)
                }
                .foregroundStyle(.appStyle)
                deleteButton
            }
        }

        // Repeat sheet view
        .sheet(isPresented: $isRepeatPickerPresented) {
            NavigationStack {
                RepeatDaysPickerView(selectedDays: $viewModel.selectedDays)
                    .navigationTitle("Repeat Days")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Back", role: .cancel) {
                                isRepeatPickerPresented.toggle()
                            }
                        }
                    }
            }
        }

        // Config navigation
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) { saveButton }
        }

        // On appear view
        .onAppear {
            viewModel.setContext(context: self.context)
        }
    }

    // MARK: Properties

    /// Repeat button view
    private var repeatButton: some View {
        return Button(
            action: {
                isRepeatPickerPresented.toggle()
            },
            label: {
                HStack {
                    Text("Repeat")
                    Spacer()
                    Text(viewModel.repeatDescription)
                }
            }
        )
    }

    /// Delete button view
    private var deleteButton: some View {
        Button(
            action: deleteMedication,
            label: {
                HStack {
                    Spacer()
                    Text("Delete")
                        .foregroundStyle(.red)
                    Spacer()
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete medication"),
                  message: Text("Are you sure?"),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        viewModel.deleteMedication()
                        dismiss()
                    }
                  ))
        }
    }

    /// Save button view
    private var saveButton: some View {
        Button("Save") {
            viewModel.saveMedication()
            dismiss()
        }
    }

    /// Cancel button view
    private var cancelButton: some View {
        Button("Cancel", role: .cancel) {
            dismiss()
        }
    }

    // MARK: Private function
    private func deleteMedication() {
        showAlert.toggle()
    }

}


// MARK: Preview
#Preview {
    MedicationFormView(medication: Medication.example)
        .modelContainer(for: Medication.self, inMemory: true)
}
