import Foundation

struct HourMinute: Codable, Equatable, Hashable {
    var hour: Int
    var minute: Int

    static let breakfast = HourMinute(hour: 8, minute: 0)
    static let lunch = HourMinute(hour: 12, minute: 0)
    static let dinner = HourMinute(hour: 18, minute: 0)

    var displayText: String {
        String(format: "%02d:%02d", hour, minute)
    }

    func date(on day: Date, calendar: Calendar = .current) -> Date {
        calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: day
        ) ?? day
    }
}
