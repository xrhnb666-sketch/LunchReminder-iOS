import XCTest
@testable import LunchReminder

final class PersistenceAndStatisticsTests: XCTestCase {
    func testSettingsCodableRoundTrip() throws {
        var settings = ReminderSettings.default
        settings.weekdaysOnly = true
        settings.selectedSound = .bear
        settings.themeMode = .dark

        let data = try JSONEncoder.reminder.encode(settings)
        let decoded = try JSONDecoder.reminder.decode(ReminderSettings.self, from: data)

        XCTAssertEqual(decoded.weekdaysOnly, true)
        XCTAssertEqual(decoded.selectedSound, .bear)
        XCTAssertEqual(decoded.themeMode, .dark)
        XCTAssertEqual(decoded.breakfastTime, .breakfast)
    }

    func testHistoryStatistics() {
        let calendar = Calendar(identifier: .gregorian)
        let now = makeDate("2026-06-11 18:30", calendar: calendar)
        let records = [
            ReminderHistoryRecord(triggeredAt: makeDate("2026-06-11 08:00", calendar: calendar), mealType: .breakfast, message: "早餐"),
            ReminderHistoryRecord(triggeredAt: makeDate("2026-06-11 12:00", calendar: calendar), mealType: .lunch, message: "午餐"),
            ReminderHistoryRecord(triggeredAt: makeDate("2026-06-10 18:00", calendar: calendar), mealType: .dinner, message: "晚餐")
        ]

        let summary = StatisticsService.summary(records: records, now: now, calendar: calendar)

        XCTAssertEqual(summary.todayCount, 2)
        XCTAssertEqual(summary.totalCount, 3)
        XCTAssertEqual(summary.breakfastCount, 1)
        XCTAssertEqual(summary.lunchCount, 1)
        XCTAssertEqual(summary.dinnerCount, 1)
        XCTAssertEqual(summary.streakDays, 2)
    }

    func testEmptyStatistics() {
        let summary = StatisticsService.summary(records: [])
        XCTAssertTrue(summary.isEmpty)
        XCTAssertEqual(summary.totalCount, 0)
    }

    private func makeDate(_ value: String, calendar: Calendar) -> Date {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: value)!
    }
}
