//
//  PushNoticeManager.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import FirebaseMessaging
import UserNotifications

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
        guard let notificationTypeString = userInfo["type"] as? String,
              let notificationType = PushNoticeTypes(rawValue: notificationTypeString) else { return }
        switch notificationType {
        case .certification:
            // TODO: 이미 모달 화면인 경우를 고려해 pushNotificationReceived로 넘기고 ModalityViewController에서 추후 컨트롤
            Task { @MainActor in
                let response: GetReviewsResponse = try await NetworkManager.shared.request(TodoCertificationsRouter.getReviews)
                if response.dailyTodoCertifications.count > 0 {
                    Task { @MainActor in
//                        ModalityManager.shared.show(reviews: response.dailyTodoCertifications)
                        // TODO: getCurrentViewController -> as BaseViewController -> coordinator.showModal
                    }
                }
            }
        case .review:
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: PushNoticeManager.pushNotificationReceived,
                    object: nil,
                    userInfo: ["type": notificationType]
                )
            }
        default:
            return
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
