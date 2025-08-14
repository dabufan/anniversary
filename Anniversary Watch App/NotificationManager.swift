import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(for anniversary: Anniversary) {
        // First, cancel any existing notification for this anniversary to avoid duplicates
        cancelNotification(for: anniversary)

        guard anniversary.reminderEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Anniversary!"
        content.body = "\(anniversary.title) is just around the corner."
        content.sound = .default

        let triggerComponents = anniversary.reminderLeadTime.triggerDateComponents(for: anniversary.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

        let request = UNNotificationRequest(identifier: anniversary.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotification(for anniversary: Anniversary) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [anniversary.id.uuidString])
    }
}
