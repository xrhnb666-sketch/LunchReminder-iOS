import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject private var settingsStore: ReminderSettingsStore

    var body: some View {
        VStack(spacing: CuteMetric.cardSpacing) {
            ForEach(ThemeMode.allCases) { mode in
                Button {
                    settingsStore.update { $0.themeMode = mode }
                } label: {
                    CuteCard {
                        HStack(spacing: 12) {
                            Image(AssetNames.stars)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                            Text(mode.label)
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(CuteColor.textPrimary)
                            Spacer()
                            if settingsStore.settings.themeMode == mode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(CuteColor.orange)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Image(AssetNames.bear)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, CuteMetric.pagePadding)
        .padding(.top, 24)
        .background(CuteColor.background.ignoresSafeArea())
        .navigationTitle("主题模式")
        .navigationBarTitleDisplayMode(.inline)
    }
}
