import SwiftUI
import UserNotifications

struct HomeView: View {
    @EnvironmentObject private var settingsStore: ReminderSettingsStore
    @State private var editingMeal: MealType?
    @State private var timeDraft = Date()

    private var settings: ReminderSettings { settingsStore.settings }
    private var nextReminder: NextReminder? { DateUtils.nextReminder(settings: settings) }
    private var todaySkipped: Bool { DateUtils.isSameDay(settings.skippedDate, Date()) }
    private var anyMealEnabled: Bool { MealType.allCases.contains { settings.isEnabled($0) } }

    var body: some View {
        ScrollView {
            VStack(spacing: CuteMetric.cardSpacing) {
                header

                ForEach(MealType.allCases) { meal in
                    MealCardView(
                        meal: meal,
                        time: settings.time(for: meal),
                        enabled: settings.isEnabled(meal),
                        todaySkipped: todaySkipped,
                        onTimeTap: { openTimePicker(for: meal) },
                        onEnabledChange: { enabled in
                            settingsStore.setEnabled(enabled, for: meal)
                            NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                            Task { await requestPermissionIfNeeded() }
                        }
                    )
                }

                if anyMealEnabled {
                    SkipTodayCardView(skipped: todaySkipped) { skipped in
                        settingsStore.setSkipToday(skipped)
                        NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                    }
                    NextReminderCardView(nextReminder: nextReminder, todaySkipped: todaySkipped)
                } else {
                    CuteCard {
                        VStack(spacing: 8) {
                            Text("今天不需要提醒啦～")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(CuteColor.textPrimary)
                            Text("记得按时吃饭哦 🍀")
                                .font(.subheadline)
                                .foregroundStyle(CuteColor.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                CuteGradientButton(title: "测试通知") {
                    Task {
                        if await requestPermissionIfNeeded() {
                            NotificationScheduler.shared.sendTestNotification(settings: settingsStore.settings)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, CuteMetric.pagePadding)
            .padding(.top, 24)
            .padding(.bottom, 108)
        }
        .background(pageBackground)
        .sheet(item: $editingMeal) { meal in
            TimeSelectionSheet(
                meal: meal,
                date: $timeDraft,
                onCancel: { editingMeal = nil },
                onSave: {
                    let components = Calendar.current.dateComponents([.hour, .minute], from: timeDraft)
                    settingsStore.setTime(
                        HourMinute(hour: components.hour ?? 12, minute: components.minute ?? 0),
                        for: meal
                    )
                    NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                    editingMeal = nil
                }
            )
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("三餐提醒")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(CuteColor.textPrimary)
                Text("按时吃饭，照顾自己")
                    .font(.subheadline)
                    .foregroundStyle(CuteColor.textSecondary)
                Text(greeting)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CuteColor.orange)
            }
            Spacer()
            Image(AssetNames.plant)
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
        }
    }

    private var pageBackground: some View {
        ZStack {
            CuteColor.background.ignoresSafeArea()
            Image(AssetNames.cloudBackground)
                .resizable()
                .scaledToFit()
                .opacity(0.10)
                .offset(y: -230)
            Image(AssetNames.starSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .opacity(0.45)
                .offset(x: -150, y: -320)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 11 { return "早安，记得吃早餐" }
        if hour < 17 { return "午安，按时吃饭哦" }
        return "晚安，好好吃饭"
    }

    private func openTimePicker(for meal: MealType) {
        editingMeal = meal
        timeDraft = settings.time(for: meal).date(on: Date())
    }

    private func requestPermissionIfNeeded() async -> Bool {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        if status == .authorized {
            return true
        }
        let granted = await NotificationScheduler.shared.requestAuthorization()
        return granted
    }
}

private struct TimeSelectionSheet: View {
    var meal: MealType
    @Binding var date: Date
    var onCancel: () -> Void
    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                DatePicker("提醒时间", selection: $date, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                Spacer()
            }
            .padding()
            .background(CuteColor.background)
            .navigationTitle(meal.shortTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存", action: onSave)
                }
            }
        }
    }
}
