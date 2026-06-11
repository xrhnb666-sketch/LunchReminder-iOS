import XCTest
@testable import LunchReminder

final class DateUtilsTests: XCTestCase {
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "zh_CN")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testBeforeBreakfastReturnsBreakfast() {
        let next = DateUtils.nextReminder(from: date("2026-06-11 07:30"), settings: .default, calendar: calendar)
        XCTAssertEqual(next?.mealType, .breakfast)
        XCTAssertEqual(DateUtils.formatTime(next!.date, calendar: calendar), "08:00")
    }

    func testBetweenBreakfastAndLunchReturnsLunch() {
        let next = DateUtils.nextReminder(from: date("2026-06-11 09:00"), settings: .default, calendar: calendar)
        XCTAssertEqual(next?.mealType, .lunch)
    }

    func testBetweenLunchAndDinnerReturnsDinner() {
        let next = DateUtils.nextReminder(from: date("2026-06-11 13:00"), settings: .default, calendar: calendar)
        XCTAssertEqual(next?.mealType, .dinner)
    }

    func testAfterDinnerReturnsNextDayBreakfast() {
        let next = DateUtils.nextReminder(from: date("2026-06-11 20:00"), settings: .default, calendar: calendar)
        XCTAssertEqual(next?.mealType, .breakfast)
        XCTAssertTrue(calendar.isDate(next!.date, inSameDayAs: date("2026-06-12 08:00")))
    }

    func testAllMealsDisabledReturnsNil() {
        var settings = ReminderSettings.default
        settings.breakfastEnabled = false
        settings.lunchEnabled = false
        settings.dinnerEnabled = false
        XCTAssertNil(DateUtils.nextReminder(from: date("2026-06-11 07:30"), settings: settings, calendar: calendar))
    }

    func testSingleMealAndTwoMealCombinations() {
        var breakfastOnly = ReminderSettings.default
        breakfastOnly.lunchEnabled = false
        breakfastOnly.dinnerEnabled = false
        XCTAssertEqual(DateUtils.nextReminder(from: date("2026-06-11 09:00"), settings: breakfastOnly, calendar: calendar)?.mealType, .breakfast)

        var lunchDinner = ReminderSettings.default
        lunchDinner.breakfastEnabled = false
        XCTAssertEqual(DateUtils.nextReminder(from: date("2026-06-11 09:00"), settings: lunchDinner, calendar: calendar)?.mealType, .lunch)
    }

    func testWeekdayModeSkipsWeekendFromFridayNight() {
        var settings = ReminderSettings.default
        settings.weekdaysOnly = true
        let next = DateUtils.nextReminder(from: date("2026-06-12 20:00"), settings: settings, calendar: calendar)
        XCTAssertEqual(next?.mealType, .breakfast)
        XCTAssertTrue(calendar.isDate(next!.date, inSameDayAs: date("2026-06-15 08:00")))
    }

    func testWeekdayModeSkipsSaturdayAndSunday() {
        var settings = ReminderSettings.default
        settings.weekdaysOnly = true
        XCTAssertTrue(calendar.isDate(DateUtils.nextReminder(from: date("2026-06-13 09:00"), settings: settings, calendar: calendar)!.date, inSameDayAs: date("2026-06-15 08:00")))
        XCTAssertTrue(calendar.isDate(DateUtils.nextReminder(from: date("2026-06-14 09:00"), settings: settings, calendar: calendar)!.date, inSameDayAs: date("2026-06-15 08:00")))
    }

    func testSkipTodayAndCancelSkip() {
        var settings = ReminderSettings.default
        settings.skippedDate = date("2026-06-11 00:00")
        XCTAssertTrue(calendar.isDate(DateUtils.nextReminder(from: date("2026-06-11 09:00"), settings: settings, calendar: calendar)!.date, inSameDayAs: date("2026-06-12 08:00")))

        settings.skippedDate = nil
        XCTAssertEqual(DateUtils.nextReminder(from: date("2026-06-11 09:00"), settings: settings, calendar: calendar)?.mealType, .lunch)
    }

    func testCrossMonthAndCrossYear() {
        XCTAssertTrue(calendar.isDate(DateUtils.nextReminder(from: date("2026-01-31 20:00"), settings: .default, calendar: calendar)!.date, inSameDayAs: date("2026-02-01 08:00")))
        XCTAssertTrue(calendar.isDate(DateUtils.nextReminder(from: date("2026-12-31 20:00"), settings: .default, calendar: calendar)!.date, inSameDayAs: date("2027-01-01 08:00")))
    }

    private func date(_ value: String) -> Date {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: value)!
    }
}
