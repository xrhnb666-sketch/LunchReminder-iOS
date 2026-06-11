# Xcode Setup

当前 Windows 环境无法编译 iOS。本目录提供 SwiftUI 源码、资源和测试文件；请在 Mac 上完成以下步骤。

## 1. 安装 Xcode

从 Mac App Store 安装最新版 Xcode。建议使用支持 iOS 16+、Swift Charts 的版本。

## 2. 新建 SwiftUI App 工程

1. 打开 Xcode。
2. 选择 `File > New > Project...`。
3. 选择 `iOS > App`。
4. Product Name 填写 `LunchReminder`。
5. Interface 选择 `SwiftUI`。
6. Language 选择 `Swift`。
7. Minimum Deployments 建议设置为 `iOS 16.0` 或更高。

## 3. 加入源码文件

将本目录下 `LunchReminder/` 内的这些文件夹拖入 Xcode 工程：

- `App`
- `Models`
- `Services`
- `Stores`
- `Views`
- `Components`
- `Utilities`
- `Resources`

拖入时选择：

- `Copy items if needed`
- 勾选 App Target

如果 Xcode 自动生成了默认 `LunchReminderApp.swift`，请删除默认文件，使用本目录中的 `App/LunchReminderApp.swift`。

## 4. 导入 Assets.xcassets

将 `LunchReminder/Assets.xcassets` 内容合并到 Xcode 工程的 `Assets.xcassets`。

确认以下资源可见：

- `AppIconPreview`
- `SplashLogo`
- `BreakfastIcon`
- `LunchIcon`
- `DinnerIcon`
- `SkipCloudIcon`
- `BearImage`
- `PlantImage`
- `CloudBackground`
- `StarsImage`
- `StarSmallImage`
- `NavHome`
- `NavHistory`
- `NavStats`
- `NavSettings`

## 5. 导入提示音

将 `LunchReminder/Resources/Sounds/` 下的 wav 文件拖入 Xcode：

- `default_sound.wav`
- `gentle_sound.wav`
- `bear_sound.wav`
- `music_sound.wav`

确保勾选 Target Membership，否则 `UNNotificationSound(named:)` 无法找到资源。

## 6. 配置 Info.plist 和 Launch Screen

将 `Resources/Info.plist` 和 `Resources/LaunchScreen.storyboard` 加入工程。

在 Target 设置中确认：

- Display Name：`三餐提醒`
- Version：`1.0.0`
- Build：`1`
- Launch Screen File：`LaunchScreen`

## 7. 设置 Bundle Identifier 和签名

在 Target > Signing & Capabilities 中：

1. 设置唯一 Bundle Identifier，例如 `com.yourname.lunchreminder`。
2. 选择你的 Apple Developer Team。
3. 确认自动签名开启。

## 8. 通知权限

本项目使用系统通知权限弹窗，不需要在 Info.plist 添加 Android 那种权限声明。

首次点击测试通知或开启提醒时，会调用 `UNUserNotificationCenter.requestAuthorization`。

## 9. 运行 iPhone Simulator

选择一个 iPhone Simulator，点击 Run。

请重点检查：

- Launch Screen 到 SwiftUI Splash 的过渡
- 首页是否出现三餐卡片
- 底部导航四页切换
- 通知权限弹窗
- 测试通知
- 提示音选择

## 10. 执行单元测试

将 `LunchReminderTests/` 加入 Test Target 后，执行：

```text
Product > Test
```

测试覆盖：

- 下一次提醒日期计算
- 工作日模式
- 周五、周六、周日
- 今日跳过 / 取消跳过
- 跨月 / 跨年
- 三餐关闭和组合开启
- 设置 Codable 编码解码
- 历史统计

## 11. Archive

确认模拟器和真机测试通过后：

1. 选择真实设备或 `Any iOS Device`。
2. 选择 `Product > Archive`。
3. 在 Organizer 中检查 Archive。

## 12. TestFlight

如需给朋友安装长期测试版本：

1. 在 Organizer 中选择 `Distribute App`。
2. 选择 App Store Connect。
3. 上传后在 App Store Connect 中添加 TestFlight 测试员。

当前阶段没有生成 IPA，也没有执行 Xcode 构建。
