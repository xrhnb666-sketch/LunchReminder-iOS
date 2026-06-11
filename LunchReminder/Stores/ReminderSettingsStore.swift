import Foundation

final class ReminderSettingsStore: ObservableObject {
    @Published private(set) var settings: ReminderSettings

    private let defaults: UserDefaults
    private let key = "reminder_settings_v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder.reminder.decode(ReminderSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }
    }

    func update(_ transform: (inout ReminderSettings) -> Void) {
        var copy = settings
        transform(&copy)
        settings = copy
        save()
    }

    func setEnabled(_ enabled: Bool, for meal: MealType) {
        update {
            switch meal {
            case .breakfast: $0.breakfastEnabled = enabled
            case .lunch: $0.lunchEnabled = enabled
            case .dinner: $0.dinnerEnabled = enabled
            }
        }
    }

    func setTime(_ time: HourMinute, for meal: MealType) {
        update {
            switch meal {
            case .breakfast: $0.breakfastTime = time
            case .lunch: $0.lunchTime = time
            case .dinner: $0.dinnerTime = time
            }
        }
    }

    func setSkipToday(_ skipped: Bool) {
        update { $0.skippedDate = skipped ? Date() : nil }
    }

    func setMessages(_ messages: [String], for meal: MealType) {
        update { $0.notificationMessages[meal] = messages.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } }
    }

    private func save() {
        guard let data = try? JSONEncoder.reminder.encode(settings) else { return }
        defaults.set(data, forKey: key)
    }
}

extension JSONEncoder {
    static var reminder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension JSONDecoder {
    static var reminder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
