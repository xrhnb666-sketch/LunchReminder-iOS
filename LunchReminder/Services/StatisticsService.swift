import Foundation

struct StatisticsSummary: Equatable {
    var todayCount: Int
    var weekCount: Int
    var monthCount: Int
    var totalCount: Int
    var breakfastCount: Int
    var lunchCount: Int
    var dinnerCount: Int
    var streakDays: Int

    var isEmpty: Bool { totalCount == 0 }

    func count(for meal: MealType) -> Int {
        switch meal {
        case .breakfast: breakfastCount
        case .lunch: lunchCount
        case .dinner: dinnerCount
        }
    }

    func ratio(for meal: MealType) -> Double {
        guard totalCount > 0 else { return 0 }
        return Double(count(for: meal)) / Double(totalCount)
    }
}

struct DailyReminderCount: Identifiable, Equatable {
    var day: Date
    var count: Int

    var id: Date { day }
}

enum StatisticsService {
    static func summary(
        records: [ReminderHistoryRecord],
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> StatisticsSummary {
        let today = records.filter { calendar.isDate($0.triggeredAt, inSameDayAs: now) }.count
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now)
        let monthInterval = calendar.dateInterval(of: .month, for: now)

        return StatisticsSummary(
            todayCount: today,
            weekCount: records.filter { weekInterval?.contains($0.triggeredAt) == true }.count,
            monthCount: records.filter { monthInterval?.contains($0.triggeredAt) == true }.count,
            totalCount: records.count,
            breakfastCount: records.filter { $0.mealType == .breakfast }.count,
            lunchCount: records.filter { $0.mealType == .lunch }.count,
            dinnerCount: records.filter { $0.mealType == .dinner }.count,
            streakDays: streakDays(records: records, now: now, calendar: calendar)
        )
    }

    static func streakDays(
        records: [ReminderHistoryRecord],
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> Int {
        let recordedDays = Set(records.map { calendar.startOfDay(for: $0.triggeredAt) })
        var cursor = calendar.startOfDay(for: now)
        var count = 0

        while recordedDays.contains(cursor) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return count
    }

    static func dailyCountsForCurrentWeek(
        records: [ReminderHistoryRecord],
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> [DailyReminderCount] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else { return [] }
        return (0..<7).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: week.start) else { return nil }
            let count = records.filter { calendar.isDate($0.triggeredAt, inSameDayAs: day) }.count
            return DailyReminderCount(day: day, count: count)
        }
    }
}
