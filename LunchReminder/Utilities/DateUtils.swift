import Foundation

struct NextReminder: Equatable {
    var mealType: MealType
    var date: Date
}

enum DateUtils {
    static func isSameDay(_ lhs: Date?, _ rhs: Date, calendar: Calendar = .current) -> Bool {
        guard let lhs else { return false }
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }

    static func isWeekday(_ date: Date, calendar: Calendar = .current) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday != 1 && weekday != 7
    }

    static func shouldSkipDay(_ date: Date, settings: ReminderSettings, calendar: Calendar = .current) -> Bool {
        if settings.weekdaysOnly && !isWeekday(date, calendar: calendar) {
            return true
        }
        if isSameDay(settings.skippedDate, date, calendar: calendar) {
            return true
        }
        return false
    }

    static func enabledMeals(in settings: ReminderSettings) -> [MealType] {
        MealType.allCases.filter { settings.isEnabled($0) }
    }

    static func nextReminder(
        from now: Date = Date(),
        settings: ReminderSettings,
        calendar: Calendar = .current
    ) -> NextReminder? {
        upcomingReminders(from: now, settings: settings, daysAhead: 30, calendar: calendar).first
    }

    static func upcomingReminders(
        from now: Date = Date(),
        settings: ReminderSettings,
        daysAhead: Int = 30,
        calendar: Calendar = .current
    ) -> [NextReminder] {
        let meals = enabledMeals(in: settings)
        guard !meals.isEmpty else { return [] }

        let startOfToday = calendar.startOfDay(for: now)
        var reminders: [NextReminder] = []

        for offset in 0..<daysAhead {
            guard let day = calendar.date(byAdding: .day, value: offset, to: startOfToday) else { continue }
            if shouldSkipDay(day, settings: settings, calendar: calendar) {
                continue
            }

            for meal in meals {
                let candidate = settings.time(for: meal).date(on: day, calendar: calendar)
                if candidate > now {
                    reminders.append(NextReminder(mealType: meal, date: candidate))
                }
            }
        }

        return reminders.sorted { $0.date < $1.date }
    }

    static func formatTime(_ date: Date, calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.calendar = calendar
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func formatDayAndTime(_ date: Date, from now: Date = Date(), calendar: Calendar = .current) -> String {
        let prefix: String
        if calendar.isDateInToday(date) {
            prefix = "今天"
        } else if calendar.isDateInTomorrow(date) {
            prefix = "明天"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.calendar = calendar
            formatter.dateFormat = "MM月dd日"
            prefix = formatter.string(from: date)
        }
        return "\(prefix) \(formatTime(date, calendar: calendar))"
    }
}
