import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var historyStore: ReminderHistoryStore
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: CuteMetric.cardSpacing) {
                    HStack {
                        Text("历史记录")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(CuteColor.textPrimary)
                        Spacer()
                        if !historyStore.records.isEmpty {
                            Button("清空") { showClearConfirm = true }
                                .foregroundStyle(CuteColor.orange)
                        }
                    }

                    if historyStore.records.isEmpty {
                        emptyState
                    } else {
                        ForEach(groupedRecords, id: \.title) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(group.title)
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(CuteColor.textPrimary)
                                CuteCard(padding: 0) {
                                    VStack(spacing: 0) {
                                        ForEach(group.records) { record in
                                            HistoryRow(record: record)
                                            if record.id != group.records.last?.id {
                                                Divider().padding(.leading, 72)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, CuteMetric.pagePadding)
                .padding(.top, 28)
                .padding(.bottom, 108)
            }
            .background(historyBackground)
            .confirmationDialog("清空历史记录？", isPresented: $showClearConfirm, titleVisibility: .visible) {
                Button("清空历史", role: .destructive) { historyStore.clear() }
                Button("取消", role: .cancel) {}
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
                Text("今天还没有提醒记录哦")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
                Text("记得按时吃饭～")
                    .font(.subheadline)
                    .foregroundStyle(CuteColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var historyBackground: some View {
        ZStack(alignment: .bottom) {
            CuteColor.background.ignoresSafeArea()
            Image(AssetNames.cloudBackground)
                .resizable()
                .scaledToFit()
                .opacity(0.15)
                .ignoresSafeArea()
        }
    }

    private var groupedRecords: [(title: String, records: [ReminderHistoryRecord])] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM月dd日"
        let grouped = Dictionary(grouping: historyStore.records) { record in
            if Calendar.current.isDateInToday(record.triggeredAt) {
                return "今天"
            }
            if Calendar.current.isDateInYesterday(record.triggeredAt) {
                return "昨天"
            }
            return formatter.string(from: record.triggeredAt)
        }
        return grouped
            .map { ($0.key, $0.value.sorted { $0.triggeredAt > $1.triggeredAt }) }
            .sorted { ($0.records.first?.triggeredAt ?? .distantPast) > ($1.records.first?.triggeredAt ?? .distantPast) }
    }
}

private struct HistoryRow: View {
    var record: ReminderHistoryRecord

    var body: some View {
        HStack(spacing: 14) {
            Image(record.mealType.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(DateUtils.formatTime(record.triggeredAt)) \(record.mealType.title)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CuteColor.textPrimary)
                Text(record.message)
                    .font(.caption)
                    .foregroundStyle(CuteColor.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(CuteColor.textSecondary.opacity(0.7))
        }
        .padding(16)
    }
}
