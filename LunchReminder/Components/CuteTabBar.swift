import SwiftUI

enum RootTab: String, CaseIterable, Identifiable {
    case home
    case history
    case statistics
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "首页"
        case .history: "历史"
        case .statistics: "统计"
        case .settings: "设置"
        }
    }

    var assetName: String {
        switch self {
        case .home: AssetNames.navHome
        case .history: AssetNames.navHistory
        case .statistics: AssetNames.navStats
        case .settings: AssetNames.navSettings
        }
    }
}

struct CuteTabBar: View {
    @Binding var selectedTab: RootTab

    var body: some View {
        HStack {
            ForEach(RootTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 3) {
                        Image(tab.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(tab.title)
                            .font(.caption2.weight(selectedTab == tab ? .bold : .regular))
                            .foregroundStyle(selectedTab == tab ? CuteColor.orange : CuteColor.textSecondary)
                        Circle()
                            .fill(selectedTab == tab ? CuteColor.orange : .clear)
                            .frame(width: 5, height: 5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 76)
        .padding(.horizontal, 10)
        .background(CuteColor.navBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .cuteShadow()
        .padding(.horizontal, CuteMetric.pagePadding)
        .padding(.bottom, 10)
    }
}
