import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: CuteMetric.cardSpacing) {
                CuteCard {
                    VStack(spacing: 12) {
                        Image(AssetNames.appIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 86, height: 86)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        Text("三餐提醒")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text("版本 1.0.0")
                            .font(.subheadline)
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }

                CuteCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("开发说明")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text("用于帮助用户按时吃早餐、午餐和晚餐。")
                            .foregroundStyle(CuteColor.textSecondary)
                        Text("本应用所有数据仅保存在本地设备。")
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                }

                CuteCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("隐私政策")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text("本应用不收集任何个人信息。所有提醒数据仅保存在本地设备。")
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                }

                CuteCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("GitHub")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(CuteColor.textPrimary)
                        Text("请在迁移到 Mac 后填写正式仓库链接。")
                            .foregroundStyle(CuteColor.textSecondary)
                    }
                }

                Text("Made with ❤️ by LunchReminder")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(CuteColor.textSecondary)
                    .padding(.top, 8)
            }
            .padding(.horizontal, CuteMetric.pagePadding)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(CuteColor.background.ignoresSafeArea())
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }
}
