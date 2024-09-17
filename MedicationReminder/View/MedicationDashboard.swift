//
//  MedicationDashboard.swift
//  Medication Reminder
//
//  Created by Udacity
//

import SwiftUI
import SwiftData

struct MedicationDashboard: View {
    @Query private var medications: [Medication]
    
    var body: some View {
        NavigationStack { // Note: NavigationStack for hierarchical navigation
            VStack {
                Text("Medication Reminders")
                    .font(.largeTitle)
                List {
                    ForEach(medications) { medication in
                        NavigationLink(destination: MedicationFormView(medication: medication)) {
                            MedicationDashboardRow(medication: medication)
                        }
                    }
                }
                // ... Other dashboard elements...
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MedicationFormView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct MedicationDashboardRow: View {
    let medication: Medication
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(medication.name)
                    .font(.headline)
                Text("Dosage: \(medication.dosage)")}
            Spacer()
            Toggle("", isOn: .constant(medication.isReminderSet))
                .labelsHidden()
        }
    }
    
}

#Preview {
    MedicationDashboard()
}


