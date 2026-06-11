# LunchReminder iOS

这是基于 Android 版 LunchReminder 功能和可爱治愈风视觉重新整理的独立 iOS SwiftUI 源码目录。

当前阶段只生成可迁移到 Mac/Xcode 的源码、资源和说明文档。此目录不是 IPA，也不是从 APK 转换得到的项目。

## 功能范围

- 早餐、午餐、晚餐三餐提醒
- 每餐独立开关和时间设置
- 今日跳过全部 / 取消今日跳过
- 仅工作日提醒
- 本地通知权限申请
- 使用 `UNUserNotificationCenter` 预排未来 30 天本地通知
- 内置提示音切换
- 历史记录
- 基础统计
- 设置页、关于页
- Launch Screen + SwiftUI Splash
- 四页底部导航：首页、历史、统计、设置

## 技术栈

- Swift
- SwiftUI
- UserNotifications
- UserDefaults + Codable
- Swift Charts

建议部署版本：iOS 16+。

## Android 到 iOS 的职责映射

- `ReminderScheduler` -> `NotificationScheduler.swift`
- `ReminderSettings` -> `ReminderSettingsStore.swift`
- `DateUtils` -> `DateUtils.swift`
- `DataStore` -> `UserDefaults + Codable`
- `Jetpack Compose` 页面 -> `SwiftUI View`
- `AlarmReceiver / BootReceiver` -> iOS 无直接对应；本版使用未来 30 天本地通知预排

## 目录结构

```text
LunchReminder-iOS/
  README.md
  ASSET_MAPPING.md
  XCODE_SETUP.md
  LunchReminder/
    App/
    Models/
    Services/
    Stores/
    Views/
    Components/
    Utilities/
    Resources/
      Info.plist
      LaunchScreen.storyboard
      Sounds/
    Assets.xcassets/
  LunchReminderTests/
```

## 注意事项

- Windows 环境无法运行 Xcode，本轮未执行 iOS 编译、模拟器测试或真机测试。
- 提示音第一版只支持 App 内置 wav，不实现 Android 的任意本地文件铃声选择。
- iOS 本地通知在 App 未运行时无法像 Android Receiver 一样执行任意代码；历史记录通过前台收到、用户点击以及 App 启动后同步已送达通知来补录。
