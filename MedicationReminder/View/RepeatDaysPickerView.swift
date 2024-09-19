//
//  RepeatDaysPickerView.swift
//  MedicationReminder
//
//  Created by huynh on 17/9/24.
//

import Foundation
import SwiftUI

struct RepeatDaysPickerView: View {
    @Binding var selectedDays: [ReminderDay]

    var body: some View {
        VStack {
            List(ReminderDay.allCases, id: \.self) { day in
                Button(action: {toggleDaySelection(day)}) {
                    HStack {
                        Text(day.title)
                            .foregroundStyle(.dynamicTextColor)
                        Spacer()
                        if selectedDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }}
            }
            Spacer()
        }
    }

    // Toggle day selection
    func toggleDaySelection(_ day: ReminderDay) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}
