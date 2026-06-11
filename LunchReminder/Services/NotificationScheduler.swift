import Foundation
import UserNotifications

final class NotificationScheduler {
    static let shared = NotificationScheduler()

    private let center: UNUserNotificationCenter
    private let scheduledDays = 30

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func rescheduleAll(settings: ReminderSettings) {
        cancelAll()
        scheduleAll(settings: settings)
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }

    func cancelMeal(_ meal: MealType) {
        center.getPendingNotificationRequests { requests in
            let identifiers = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(meal.notificationIdentifierPrefix) }
            self.center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }

    func scheduleAll(settings: ReminderSettings, from now: Date = Date()) {
        let reminders = DateUtils.upcomingReminders(
            from: now,
            settings: settings,
            daysAhead: scheduledDays
        )

        for reminder in reminders {
            schedule(reminder: reminder, settings: settings)
        }
    }

    func sendTestNotification(settings: ReminderSettings) {
        let content = UNMutableNotificationContent()
        content.title = "午餐提醒"
        content.body = settings.message(for: .lunch)
        content.sound = sound(for: settings)

        let request = UNNotificationRequest(
            identifier: "test_lunch_reminder",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        center.add(request)
    }

    private func schedule(reminder: NextReminder, settings: ReminderSettings) {
        let content = UNMutableNotificationContent()
        content.title = reminder.mealType.title
        content.body = settings.message(for: reminder.mealType)
        content.sound = sound(for: settings)
        content.userInfo = [
            "mealType": reminder.mealType.rawValue,
            "fireDate": reminder.date.timeIntervalSince1970
        ]

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminder.date
        )
        let identifier = "\(reminder.mealType.notificationIdentifierPrefix)_\(Int(reminder.date.timeIntervalSince1970))"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        )
        center.add(request)
    }

    private func sound(for settings: ReminderSettings) -> UNNotificationSound {
        guard
            let fileName = settings.selectedSound.resourceFileName,
            Bundle.main.url(forResource: fileName, withExtension: nil) != nil
        else {
            return .default
        }
        return UNNotificationSound(named: UNNotificationSoundName(fileName))
    }
}
