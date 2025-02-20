//
//  PushNoticeManager.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import UserNotifications
import FirebaseMessaging

final class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushNoticeManager()
    private override init() {
        super.init()
        Task {
            await setupNotificationDelegate()
            try await checkAuthorization()
        }
    }
    static let pushNotificationReceived = Notification.Name("PushNotificationReceived")
    
    private func setupNotificationDelegate() async {
        await MainActor.run {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    private func checkAuthorization() async throws {
        let userNoti = UNUserNotificationCenter.current()
        let settings = await userNoti.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            try await userNoti.requestAuthorization(options: [.alert, .badge, .sound])
        case .denied:
            SystemManager().openSettingApp()    // TODO: 추후 Alert 추가
        default:    // MARK: .authorized, .provisional, .ephemeral
            break
        }
    }
    
    private func handleNotification(notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        if let notificationType = userInfo["type"] as? String {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: PushNoticeManager.pushNotificationReceived,
                    object: nil,
                    userInfo: ["type": notificationType]
                )
            }
        }
    }
    
    // MARK: - foreground
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        handleNotification(notification: notification)
        completionHandler([.banner, .sound])
    }
    
    // MARK: - background
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        handleNotification(notification: response.notification)
        completionHandler()
    }
}
