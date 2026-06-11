import SwiftUI
import UserNotifications

@main
struct LunchReminderApp: App {
    @UIApplicationDelegateAdaptor(AppNotificationDelegate.self) private var appDelegate
    @StateObject private var settingsStore = ReminderSettingsStore()
    @StateObject private var historyStore = ReminderHistoryStore()

    var body: some Scene {
        WindowGroup {
            AppBootstrapView()
                .environmentObject(settingsStore)
                .environmentObject(historyStore)
                .preferredColorScheme(settingsStore.settings.themeMode.colorScheme)
                .onAppear {
                    appDelegate.historyStore = historyStore
                    UNUserNotificationCenter.current().delegate = appDelegate
                    historyStore.syncDeliveredNotifications()
                    NotificationScheduler.shared.scheduleAll(settings: settingsStore.settings)
                }
        }
    }
}

final class AppNotificationDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    weak var historyStore: ReminderHistoryStore?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        recordIfNeeded(notification.request)
        return [.banner, .sound, .list]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        recordIfNeeded(response.notification.request)
    }

    private func recordIfNeeded(_ request: UNNotificationRequest) {
        guard !request.identifier.hasPrefix("test_"),
              let record = ReminderHistoryStore.record(from: request)
        else {
            return
        }
        Task { @MainActor in
            historyStore?.add(record)
        }
    }
}

struct AppBootstrapView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                RootTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showSplash)
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            showSplash = false
        }
    }
}
