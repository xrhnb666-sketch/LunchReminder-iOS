import SwiftUI

struct SkipTodayCardView: View {
    var skipped: Bool
    var onChange: (Bool) -> Void

    var body: some View {
        CuteCard(background: CuteColor.skip) {
            HStack(spacing: 14) {
                Image(AssetNames.skipCloud)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)

                VStack(alignment: .leading, spacing: 5) {
                    Text("今日跳过全部")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(CuteColor.textPrimary)
                    Text("开启后今天不再提醒")
                        .font(.footnote)
                        .foregroundStyle(CuteColor.textSecondary)
                }

                Spacer()

                Toggle("", isOn: Binding(get: { skipped }, set: onChange))
                    .labelsHidden()
                    .tint(CuteColor.orange)
            }
        }
    }
}

struct NextReminderCardView: View {
    var nextReminder: NextReminder?
    var todaySkipped: Bool

    var body: some View {
        CuteCard {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(todaySkipped ? "今天已跳过全部提醒" : "⏰ 下一次提醒")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(CuteColor.textPrimary)
                    if let nextReminder {
                        Text(DateUtils.formatDayAndTime(nextReminder.date))
                            .font(.title2.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text(nextReminder.mealType.title)
                            .font(.subheadline)
                            .foregroundStyle(CuteColor.textSecondary)
                    } else {
                        Text("今天不需要提醒啦～")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text("记得按时吃饭哦")
                            .font(.subheadline)
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(CuteColor.textSecondary)
            }
        }
    }
}
