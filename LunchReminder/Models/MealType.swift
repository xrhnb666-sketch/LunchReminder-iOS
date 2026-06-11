import Foundation

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner

    var id: String { rawValue }

    var title: String {
        switch self {
        case .breakfast: "早餐提醒"
        case .lunch: "午餐提醒"
        case .dinner: "晚餐提醒"
        }
    }

    var shortTitle: String {
        switch self {
        case .breakfast: "早餐"
        case .lunch: "午餐"
        case .dinner: "晚餐"
        }
    }

    var assetName: String {
        switch self {
        case .breakfast: "BreakfastIcon"
        case .lunch: "LunchIcon"
        case .dinner: "DinnerIcon"
        }
    }

    var notificationIdentifierPrefix: String {
        switch self {
        case .breakfast: "breakfast_reminder"
        case .lunch: "lunch_reminder"
        case .dinner: "dinner_reminder"
        }
    }

    var defaultMessage: String {
        switch self {
        case .breakfast: "记得吃早餐，开启活力一天"
        case .lunch: "记得按时吃饭"
        case .dinner: "辛苦一天，记得好好吃饭"
        }
    }
}
