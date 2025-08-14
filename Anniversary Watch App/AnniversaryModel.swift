import Foundation
import SwiftData

enum ReminderLeadTime: String, Codable, CaseIterable, Identifiable {
    case onDay = "On the day"
    case oneDayBefore = "1 day before"
    case oneWeekBefore = "1 week before"

    var id: String { self.rawValue }

    func triggerDateComponents(for anniversaryDate: Date) -> DateComponents {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .day], from: anniversaryDate)

        var reminderDate = calendar.date(from: components)!

        switch self {
        case .onDay:
            break
        case .oneDayBefore:
            reminderDate = calendar.date(byAdding: .day, value: -1, to: reminderDate)!
        case .oneWeekBefore:
            reminderDate = calendar.date(byAdding: .day, value: -7, to: reminderDate)!
        }

        var triggerComponents = calendar.dateComponents([.month, .day], from: reminderDate)
        triggerComponents.hour = 9 // Remind at 9 AM
        return triggerComponents
    }
}

enum Category: String, Codable, CaseIterable, Identifiable {
    case birthday = "Birthday"
    case wedding = "Wedding"
    case holiday = "Holiday"
    case other = "Other"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .birthday:
            return "gift.fill"
        case .wedding:
            return "heart.fill"
        case .holiday:
            return "party.popper.fill"
        case .other:
            return "star.fill"
        }
    }
}

@Model
final class Anniversary {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    var category: Category
    var reminderEnabled: Bool
    var reminderLeadTime: ReminderLeadTime

    init(title: String, date: Date, category: Category = .other, reminderEnabled: Bool = false, reminderLeadTime: ReminderLeadTime = .onDay) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.category = category
        self.reminderEnabled = reminderEnabled
        self.reminderLeadTime = reminderLeadTime
    }
}
