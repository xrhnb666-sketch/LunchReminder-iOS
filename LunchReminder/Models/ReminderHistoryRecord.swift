import Foundation

struct ReminderHistoryRecord: Codable, Equatable, Identifiable {
    var id: UUID
    var triggeredAt: Date
    var mealType: MealType
    var message: String
    var delivered: Bool

    init(
        id: UUID = UUID(),
        triggeredAt: Date,
        mealType: MealType,
        message: String,
        delivered: Bool = true
    ) {
        self.id = id
        self.triggeredAt = triggeredAt
        self.mealType = mealType
        self.message = message
        self.delivered = delivered
    }
}
