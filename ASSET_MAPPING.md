# Asset Mapping

| Android 资源名 | iOS Asset 名称 / 路径 | 使用页面 |
|---|---|---|
| `drawable/app_icon.png` | `Assets.xcassets/AppIconPreview.imageset` | About、Launch Screen 简化图标 |
| `drawable/splash_logo.png` | `Assets.xcassets/SplashLogo.imageset` | `SplashView` |
| `drawable/ic_breakfast.png` | `Assets.xcassets/BreakfastIcon.imageset` | 首页早餐卡、历史、设置 |
| `drawable/ic_lunch.png` | `Assets.xcassets/LunchIcon.imageset` | 首页午餐卡、历史 |
| `drawable/ic_dinner.png` | `Assets.xcassets/DinnerIcon.imageset` | 首页晚餐卡、历史 |
| `drawable/ic_skip_cloud.png` | `Assets.xcassets/SkipCloudIcon.imageset` | 今日跳过、通知文案入口 |
| `drawable/img_bear.png` | `Assets.xcassets/BearImage.imageset` | 历史空状态、统计空状态、主题页 |
| `drawable/img_plant.png` | `Assets.xcassets/PlantImage.imageset` | 首页/设置页顶部装饰 |
| `drawable/img_cloud_bg.png` | `Assets.xcassets/CloudBackground.imageset` | 首页、历史、设置背景 |
| `drawable/img_stars.png` | `Assets.xcassets/StarsImage.imageset` | 统计背景、设置入口 |
| `drawable/img_star_small.png` | `Assets.xcassets/StarSmallImage.imageset` | 首页/设置背景小装饰 |
| `drawable/decor_flower.png` | `Assets.xcassets/FlowerDecor.imageset` | 预留装饰 |
| `drawable/nav_home.png` | `Assets.xcassets/NavHome.imageset` | 底部导航：首页 |
| `drawable/nav_history.png` | `Assets.xcassets/NavHistory.imageset` | 底部导航：历史 |
| `drawable/nav_stats.png` | `Assets.xcassets/NavStats.imageset` | 底部导航：统计 |
| `drawable/nav_settings.png` | `Assets.xcassets/NavSettings.imageset` | 底部导航：设置 |
| `raw/default_sound.wav` | `Resources/Sounds/default_sound.wav` | 默认铃声 |
| `raw/gentle_sound.wav` | `Resources/Sounds/gentle_sound.wav` | 温柔铃声 |
| `raw/bear_sound.wav` | `Resources/Sounds/bear_sound.wav` | 小熊铃声 |
| `raw/music_sound.wav` | `Resources/Sounds/music_sound.wav` | 轻音乐 |

## App Icon 说明

当前 `AppIconPreview` 可用于 App 内展示和 Launch Screen。正式上架或 TestFlight 前，需要在 Xcode 中创建 `AppIcon.appiconset`，并使用用户提供的正式图标生成 iOS 所需尺寸。
