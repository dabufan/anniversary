import SwiftUI
import SwiftData

struct EditAnniversaryView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var anniversary: Anniversary

    var body: some View {
        VStack {
            TextField("Title", text: $anniversary.title)
            DatePicker("Date", selection: $anniversary.date, displayedComponents: .date)

            Picker("Category", selection: $anniversary.category) {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.wheel)

            Toggle("Enable Reminder", isOn: $anniversary.reminderEnabled)

            if anniversary.reminderEnabled {
                Picker("Remind Me", selection: $anniversary.reminderLeadTime) {
                    ForEach(ReminderLeadTime.allCases) { leadTime in
                        Text(leadTime.rawValue).tag(leadTime)
                    }
                }
            }

            Button("Done") {
                dismiss()
            }
            .disabled(anniversary.title.isEmpty)
        }
        .padding()
        .navigationTitle("Edit Anniversary")
        .onDisappear {
            NotificationManager.shared.scheduleNotification(for: anniversary)
        }
    }
}
