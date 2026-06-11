import SwiftUI

struct SettingSectionCard<Content: View>: View {
    var title: String
    var iconName: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(CuteColor.textPrimary)
            }
            CuteCard(padding: 0) {
                VStack(spacing: 0) {
                    content
                }
            }
        }
    }
}

struct SettingNavigationRow: View {
    var title: String
    var subtitle: String
    var iconName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            SettingRowContent(title: title, subtitle: subtitle, iconName: iconName)
        }
        .buttonStyle(.plain)
    }
}

struct SettingRowContent: View {
    var title: String
    var subtitle: String
    var iconName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CuteColor.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(CuteColor.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(CuteColor.textSecondary)
        }
        .padding(16)
    }
}

struct SettingToggleRow: View {
    var title: String
    var subtitle: String
    var iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CuteColor.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(CuteColor.textSecondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(CuteColor.orange)
        }
        .padding(16)
    }
}
