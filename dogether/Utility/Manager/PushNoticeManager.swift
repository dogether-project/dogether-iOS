//
//  PushNoticeManager.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushNoticeManager()
    private override init() {
        super.init()
        Task {
            await setupNotificationDelegate()
            try await checkAuthorization()
        }
    }
    
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
            if try await userNoti.requestAuthorization(options: [.alert, .badge, .sound]) {
                await UIApplication.shared.registerForRemoteNotifications()
            }
        case .denied:
            break   // TODO: 알림이 꺼져있다는 Alert 등으로 사용자를 설정 앱으로 유도
        default:    // MARK: .authorized, .provisional, .ephemeral
            break
        }
    }
    
    // MARK: - foreground
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("foreground notification: \(notification)")
        
        completionHandler([.banner, .sound])
    }
    
    // MARK: - background
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("background notification: \(response.notification)")
        
        completionHandler()
    }
}
