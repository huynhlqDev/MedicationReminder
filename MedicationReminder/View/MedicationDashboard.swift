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
    @State private var selectedDate = Date()

    @State private var isShowResetToday: Bool = false

    private let currentDate = Date()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor]
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(selectedDate.getMonth())
                        .font(.title)
                        .bold()
                        .padding(.leading)
                        .foregroundStyle(.appStyle)
                    Spacer()
                    if isShowResetToday {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title)
                            .padding(.trailing)
                            .foregroundStyle(.appStyle)
                            .onTapGesture {
                                selectedDate = Date()
                                isShowResetToday = selectedDate.getDateWithoutTime() != Date().getDateWithoutTime()
                            }
                    }

                }
                calendarView
                Spacer(minLength: 20)
                VStack {
                    // To take view
                    HStack {
                        Text("To Take")
                            .foregroundStyle(.white)
                            .font(.title3)
                            .bold()
                        Spacer()
                        NavigationLink(destination: MedicationFormView()) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.white)
                                .font(.title)
                        }
                    }
                    .padding( .horizontal, 30)
                    .padding( .top, 30)

                    // List view
                    List {
                        ForEach(
                            medications
                                .filter {
                                    $0.reminderDays.contains(ReminderDay(rawValue: selectedDate.getDayShort())!)
                                }
                        ) { medication in
                            NavigationLink(destination: MedicationFormView(medication: medication)) {
                                MedicationDashboardRow(medication: medication)
                            }
                            .padding()
                            .background(.white)
                            .listRowBackground(Color.clear)
                            .cornerRadius(16)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .frame(maxHeight: .infinity)
                .background(.appStyle)
                .cornerRadius(20)
            }

            // Navigation view
            .navigationTitle("Today's reminder")
        }
    }

    /// Calendar view
    var calendarView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedDate.getWeek(), id: \.self) { day in
                            VStack {
                                Text(day.getDayShort())
                                    .font(.body)
                                Text("\(day.getDayNumber())")
                                    .font(.title)
                            }
                            .frame(width: UIScreen.screenWidth/8, height: 64)
                            .background((selectedDate == day) ? .appStyle : Color.clear)
                            .foregroundStyle((selectedDate == day) ? .white : .appStyle)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedDate = day
                                isShowResetToday = selectedDate.getDateWithoutTime() != Date().getDateWithoutTime()
                            }
                        }
                    }
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(selectedDate, anchor: .center)
                        }
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.appStyle)
                Text("Dosage: \(medication.dosage)")
                    .foregroundStyle(.appStyle)
                    .font(.footnote)
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.appStyle)
                    Text(timeString(from: medication.time))
                        .foregroundStyle(.appStyle)
                    Spacer()
                    Image(systemName: medication.isReminderSet ? "bell.fill" : "bell.slash.fill")
                        .foregroundStyle(medication.isReminderSet ? .green : .red)
                }
                .font(.headline)
                .padding(.top, 4)
            }
        }
    }

    func timeString(from interval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: interval)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    MedicationDashboard()
}


