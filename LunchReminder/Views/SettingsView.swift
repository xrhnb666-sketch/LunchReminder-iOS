import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsStore: ReminderSettingsStore
    @State private var showSoundDialog = false
    @State private var showUpdateMessage = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: CuteMetric.cardSpacing) {
                    header

                    SettingSectionCard(title: "提醒设置", iconName: "BreakfastIcon") {
                        SettingToggleRow(
                            title: "仅工作日提醒",
                            subtitle: "周六周日自动跳过",
                            iconName: "BreakfastIcon",
                            isOn: Binding(
                                get: { settingsStore.settings.weekdaysOnly },
                                set: { value in
                                    settingsStore.update { $0.weekdaysOnly = value }
                                    NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                                }
                            )
                        )
                        Divider().padding(.leading, 60)
                        SettingToggleRow(
                            title: "今日跳过全部",
                            subtitle: "开启后今天不再提醒",
                            iconName: AssetNames.skipCloud,
                            isOn: Binding(
                                get: { DateUtils.isSameDay(settingsStore.settings.skippedDate, Date()) },
                                set: { value in
                                    settingsStore.setSkipToday(value)
                                    NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                                }
                            )
                        )
                        Divider().padding(.leading, 60)
                        NavigationLink {
                            NotificationMessageView()
                        } label: {
                            SettingRowContent(
                                title: "通知文案设置",
                                subtitle: "自定义三餐提醒文案",
                                iconName: AssetNames.skipCloud
                            )
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 60)
                        SettingNavigationRow(
                            title: "提示音",
                            subtitle: "当前：\(settingsStore.settings.selectedSound.displayName)",
                            iconName: AssetNames.stars,
                            action: { showSoundDialog = true }
                        )
                    }

                    SettingSectionCard(title: "外观设置", iconName: AssetNames.plant) {
                        NavigationLink {
                            ThemeSelectionView()
                        } label: {
                            SettingRowContent(
                                title: "主题模式",
                                subtitle: settingsStore.settings.themeMode.label,
                                iconName: AssetNames.stars
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    SettingSectionCard(title: "关于", iconName: AssetNames.plant) {
                        NavigationLink {
                            AboutView()
                        } label: {
                            SettingRowContent(
                                title: "关于 三餐提醒",
                                subtitle: "版本、隐私和开发说明",
                                iconName: AssetNames.appIcon
                            )
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 60)
                        SettingNavigationRow(
                            title: "检查更新",
                            subtitle: "当前版本：1.0.0",
                            iconName: AssetNames.stars,
                            action: { showUpdateMessage = true }
                        )
                    }
                }
                .padding(.horizontal, CuteMetric.pagePadding)
                .padding(.top, 28)
                .padding(.bottom, 108)
            }
            .background(settingsBackground)
            .confirmationDialog("选择提示音", isPresented: $showSoundDialog, titleVisibility: .visible) {
                ForEach(NotificationSoundOption.allCases) { sound in
                    Button(sound.displayName) {
                        settingsStore.update { $0.selectedSound = sound }
                        NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                    }
                }
                Button("取消", role: .cancel) {}
            }
            .alert("当前已是最新版本", isPresented: $showUpdateMessage) {
                Button("好") {}
            } message: {
                Text("当前版本：1.0.0")
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            Text("设置")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(CuteColor.textPrimary)
            Spacer()
            Image(AssetNames.plant)
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
        }
    }

    private var settingsBackground: some View {
        ZStack(alignment: .bottom) {
            CuteColor.background.ignoresSafeArea()
            Image(AssetNames.cloudBackground)
                .resizable()
                .scaledToFit()
                .opacity(0.10)
                .ignoresSafeArea()
            Image(AssetNames.starSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .opacity(0.35)
                .offset(x: -145, y: -310)
        }
    }
}
