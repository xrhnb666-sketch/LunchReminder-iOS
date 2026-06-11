import Foundation
import UserNotifications

final class ReminderHistoryStore: ObservableObject {
    @Published private(set) var records: [ReminderHistoryRecord]

    private let defaults: UserDefaults
    private let key = "reminder_history_v1"
    private let syncedIdentifiersKey = "reminder_history_synced_ids_v1"
    private let maxRecords = 100

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder.reminder.decode([ReminderHistoryRecord].self, from: data) {
            records = decoded
        } else {
            records = []
        }
    }

    func add(_ record: ReminderHistoryRecord) {
        records.insert(record, at: 0)
        records = Array(records.prefix(maxRecords))
        save()
    }

    func clear() {
        records.removeAll()
        defaults.removeObject(forKey: syncedIdentifiersKey)
        save()
    }

    func syncDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { [weak self] notifications in
            guard let self else { return }
            Task { @MainActor in
                var synced = Set(self.defaults.stringArray(forKey: self.syncedIdentifiersKey) ?? [])
                for notification in notifications where !synced.contains(notification.request.identifier) {
                    guard let record = Self.record(from: notification.request) else { continue }
                    self.add(record)
                    synced.insert(notification.request.identifier)
                }
                self.defaults.set(Array(synced), forKey: self.syncedIdentifiersKey)
            }
        }
    }

    static func record(from request: UNNotificationRequest) -> ReminderHistoryRecord? {
        guard
            let mealRaw = request.content.userInfo["mealType"] as? String,
            let meal = MealType(rawValue: mealRaw)
        else {
            return nil
        }

        let fireDate = request.content.userInfo["fireDate"] as? TimeInterval
        return ReminderHistoryRecord(
            triggeredAt: fireDate.map(Date.init(timeIntervalSince1970:)) ?? Date(),
            mealType: meal,
            message: request.content.body
        )
    }

    private func save() {
        guard let data = try? JSONEncoder.reminder.encode(records) else { return }
        defaults.set(data, forKey: key)
    }
}
