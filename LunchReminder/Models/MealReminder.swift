import Foundation

struct MealReminder: Codable, Equatable, Identifiable {
    var type: MealType
    var time: HourMinute
    var enabled: Bool

    var id: MealType { type }
}
