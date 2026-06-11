import SwiftUI

struct NotificationMessageView: View {
    @EnvironmentObject private var settingsStore: ReminderSettingsStore
    @State private var drafts: [MealType: String] = [:]

    var body: some View {
        ScrollView {
            VStack(spacing: CuteMetric.cardSpacing) {
                ForEach(MealType.allCases) { meal in
                    CuteCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(meal.assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                Text("\(meal.shortTitle)文案")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(CuteColor.textPrimary)
                            }
                            Text("每行一条，通知时随机选择")
                                .font(.caption)
                                .foregroundStyle(CuteColor.textSecondary)
                            TextEditor(text: Binding(
                                get: { drafts[meal] ?? "" },
                                set: { drafts[meal] = $0 }
                            ))
                            .frame(height: 120)
                            .scrollContentBackground(.hidden)
                            .padding(10)
                            .background(Color(hex: 0xFFF8EF))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }

                CuteGradientButton(title: "保存文案") {
                    for meal in MealType.allCases {
                        let lines = (drafts[meal] ?? "")
                            .split(separator: "\n")
                            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                        settingsStore.setMessages(lines, for: meal)
                    }
                    NotificationScheduler.shared.rescheduleAll(settings: settingsStore.settings)
                }
            }
            .padding(.horizontal, CuteMetric.pagePadding)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(CuteColor.background.ignoresSafeArea())
        .navigationTitle("通知文案设置")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            drafts = Dictionary(
                uniqueKeysWithValues: MealType.allCases.map {
                    ($0, (settingsStore.settings.notificationMessages[$0] ?? [$0.defaultMessage]).joined(separator: "\n"))
                }
            )
        }
    }
}
