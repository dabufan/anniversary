import SwiftUI

struct AnniversaryDetailView: View {
    let anniversary: Anniversary

    private var daysRemaining: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let nextAnniversaryDate = calendar.nextDate(after: today, matching: calendar.dateComponents([.month, .day], from: anniversary.date), matchingPolicy: .nextTime)!
        let days = calendar.dateComponents([.day], from: today, to: nextAnniversaryDate).day!
        return days
    }

    private var isToday: Bool {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.month, .day], from: Date())
        let anniversaryComponents = calendar.dateComponents([.month, .day], from: anniversary.date)
        return todayComponents.month == anniversaryComponents.month && todayComponents.day == anniversaryComponents.day
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(anniversary.title)
                    .font(.largeTitle)
                Text("Date: \(anniversary.date, formatter: Self.dateFormatter)")
                Divider()
                Text(isToday ? "Happy Anniversary!" : "\(daysRemaining) days until next anniversary")
                    .font(.title2)
                Spacer()
            }

            if isToday {
                ConfettiView()
            }
        }
        .padding()
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditAnniversaryView(anniversary: anniversary)
        }
    }

    @State private var isEditing = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
