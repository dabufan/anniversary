import SwiftUI
import SwiftData

struct AddAnniversaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var date = Date()
    @State private var category: Category = .other
    @State private var reminderEnabled = false
    @State private var reminderLeadTime: ReminderLeadTime = .onDay

    var body: some View {
        VStack {
            TextField("Title", text: $title)
            DatePicker("Date", selection: $date, displayedComponents: .date)

            Picker("Category", selection: $category) {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }

            Toggle("Enable Reminder", isOn: $reminderEnabled)

            if reminderEnabled {
                Picker("Remind Me", selection: $reminderLeadTime) {
                    ForEach(ReminderLeadTime.allCases) { leadTime in
                        Text(leadTime.rawValue).tag(leadTime)
                    }
                }
            }

            Button("Save") {
                let newAnniversary = Anniversary(title: title, date: date, category: category, reminderEnabled: reminderEnabled, reminderLeadTime: reminderLeadTime)
                modelContext.insert(newAnniversary)
                NotificationManager.shared.scheduleNotification(for: newAnniversary)
                isPresented = false
            }
            .disabled(title.isEmpty)
        }
        .padding()
    }
}
