import Charts
import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject private var historyStore: ReminderHistoryStore

    private var summary: StatisticsSummary {
        StatisticsService.summary(records: historyStore.records)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CuteMetric.cardSpacing) {
                Text("统计分析")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(CuteColor.textPrimary)

                if summary.isEmpty {
                    emptyState
                } else {
                    todayCard
                    distributionCard
                    trendCard
                }
            }
            .padding(.horizontal, CuteMetric.pagePadding)
            .padding(.top, 28)
            .padding(.bottom, 108)
        }
        .background(statsBackground)
    }

    private var todayCard: some View {
        CuteCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("今日数据")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
                HStack {
                    statCell("今日提醒", "\(summary.todayCount)")
                    statCell("本周提醒", "\(summary.weekCount)")
                    statCell("本月提醒", "\(summary.monthCount)")
                    statCell("连续提醒天数", "\(summary.streakDays)")
                }
            }
        }
    }

    private var distributionCard: some View {
        CuteCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("餐次分布")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
                HStack(spacing: 22) {
                    DistributionRing(summary: summary)
                        .frame(width: 112, height: 112)
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(MealType.allCases) { meal in
                            HStack {
                                Circle()
                                    .fill(color(for: meal))
                                    .frame(width: 9, height: 9)
                                Text(meal.shortTitle)
                                    .foregroundStyle(CuteColor.textPrimary)
                                Spacer()
                                Text("\(Int(summary.ratio(for: meal) * 100))% (\(summary.count(for: meal)))")
                                    .foregroundStyle(CuteColor.textSecondary)
                            }
                            .font(.caption)
                        }
                    }
                }
            }
        }
    }

    private var trendCard: some View {
        CuteCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("每日趋势（本周）")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
                Chart {
                    ForEach(StatisticsService.dailyCountsForCurrentWeek(records: historyStore.records)) { item in
                        LineMark(
                            x: .value("日期", item.day, unit: .day),
                            y: .value("次数", item.count)
                        )
                        .foregroundStyle(CuteColor.orange)
                        PointMark(
                            x: .value("日期", item.day, unit: .day),
                            y: .value("次数", item.count)
                        )
                        .foregroundStyle(CuteColor.orange)
                    }
                }
                .frame(height: 190)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }

    private var emptyState: some View {
        CuteCard {
            VStack(spacing: 10) {
                Image(AssetNames.bear)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                Text("暂无统计数据")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
                Text("继续坚持按时吃饭吧～")
                    .font(.subheadline)
                    .foregroundStyle(CuteColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var statsBackground: some View {
        ZStack {
            CuteColor.background.ignoresSafeArea()
            Image(AssetNames.stars)
                .resizable()
                .scaledToFit()
                .opacity(0.08)
                .offset(y: -240)
        }
    }

    private func statCell(_ title: String, _ value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(CuteColor.textPrimary)
            Text(title)
                .font(.caption2)
                .foregroundStyle(CuteColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func color(for meal: MealType) -> Color {
        switch meal {
        case .breakfast: Color(hex: 0xF6C36A)
        case .lunch: CuteColor.orange
        case .dinner: CuteColor.green
        }
    }
}

private struct DistributionRing: View {
    var summary: StatisticsSummary

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: 0xF3E4D4), lineWidth: 22)
            ringSegment(start: 0, ratio: summary.ratio(for: .breakfast), color: Color(hex: 0xF6C36A))
            ringSegment(start: summary.ratio(for: .breakfast), ratio: summary.ratio(for: .lunch), color: CuteColor.orange)
            ringSegment(start: summary.ratio(for: .breakfast) + summary.ratio(for: .lunch), ratio: summary.ratio(for: .dinner), color: CuteColor.green)
        }
        .rotationEffect(.degrees(-90))
    }

    private func ringSegment(start: Double, ratio: Double, color: Color) -> some View {
        Circle()
            .trim(from: start, to: start + ratio)
            .stroke(color, style: StrokeStyle(lineWidth: 22, lineCap: .round))
    }
}
