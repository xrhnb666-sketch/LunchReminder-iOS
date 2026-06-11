import SwiftUI

struct MealCardView: View {
    var meal: MealType
    var time: HourMinute
    var enabled: Bool
    var todaySkipped: Bool
    var onTimeTap: () -> Void
    var onEnabledChange: (Bool) -> Void

    var body: some View {
        CuteCard(background: cardColor) {
            HStack(spacing: 14) {
                Image(meal.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .padding(7)
                    .background(Color.white.opacity(0.72))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                Button(action: onTimeTap) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(meal.shortTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text(time.displayText)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(accentColor)
                        Text(todaySkipped ? "今日已跳过" : subtitle)
                            .font(.footnote)
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)

                Toggle("", isOn: Binding(get: { enabled }, set: onEnabledChange))
                    .labelsHidden()
                    .tint(accentColor)
            }
        }
    }

    private var cardColor: Color {
        switch meal {
        case .breakfast: CuteColor.breakfast
        case .lunch: CuteColor.lunch
        case .dinner: CuteColor.dinner
        }
    }

    private var accentColor: Color {
        switch meal {
        case .breakfast: CuteColor.orangeLight
        case .lunch: Color(hex: 0xF79B37)
        case .dinner: CuteColor.green
        }
    }

    private var subtitle: String {
        switch meal {
        case .breakfast: "清晨能量"
        case .lunch: "先吃饭呀"
        case .dinner: "好好收尾"
        }
    }
}
