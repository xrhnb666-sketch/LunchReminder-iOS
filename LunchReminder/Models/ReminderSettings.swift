import Foundation

struct ReminderSettings: Codable, Equatable {
    var breakfastTime: HourMinute
    var lunchTime: HourMinute
    var dinnerTime: HourMinute
    var breakfastEnabled: Bool
    var lunchEnabled: Bool
    var dinnerEnabled: Bool
    var weekdaysOnly: Bool
    var skippedDate: Date?
    var selectedSound: NotificationSoundOption
    var notificationMessages: [MealType: [String]]
    var themeMode: ThemeMode

    static let `default` = ReminderSettings(
        breakfastTime: .breakfast,
        lunchTime: .lunch,
        dinnerTime: .dinner,
        breakfastEnabled: true,
        lunchEnabled: true,
        dinnerEnabled: true,
        weekdaysOnly: false,
        skippedDate: nil,
        selectedSound: .systemDefault,
        notificationMessages: [
            .breakfast: ["早餐时间到了", "记得吃早餐，开启活力一天"],
            .lunch: ["午饭时间到了", "别忘记吃饭", "放下工作先吃饭"],
            .dinner: ["晚饭时间到了", "辛苦一天，记得好好吃饭"]
        ],
        themeMode: .system
    )

    func time(for meal: MealType) -> HourMinute {
        switch meal {
        case .breakfast: breakfastTime
        case .lunch: lunchTime
        case .dinner: dinnerTime
        }
    }

    func isEnabled(_ meal: MealType) -> Bool {
        switch meal {
        case .breakfast: breakfastEnabled
        case .lunch: lunchEnabled
        case .dinner: dinnerEnabled
        }
    }

    func message(for meal: MealType) -> String {
        notificationMessages[meal]?.randomElement() ?? meal.defaultMessage
    }
}
