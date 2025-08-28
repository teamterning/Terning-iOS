//
//  AppDelegate.swift
//  Terning-iOS
//
//  Created by 이명진 on 6/19/24.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon

import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KakaoSDK.initSDK(appKey: Config.KakaoAppKey)
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        setupFCM(application)
        
        // 푸시 알림 이벤트 추적: 앱 종료 상태에서 푸시 클릭으로 앱 실행
        // 앱이 완전히 종료된 상태에서 사용자가 푸시 알림을 탭하여 앱이 실행될 때 호출
        // push_notification_opened 이벤트가 Amplitude에 정상적으로 로깅됨
        if let notificationUserInfo = launchOptions?[.remoteNotification] as? [String: Any] {
            track(eventName: .pushNotificationOpened)
            print("🔔 앱 종료 상태에서 푸시 알림 클릭으로 실행됨")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tokenString = tokenParts.joined()
        print("🔐 APNs 기기 토큰(token) : \(tokenString)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// 푸시 알림 이벤트 추적: 백그라운드/포그라운드에서 푸시 클릭
    /// 앱이 백그라운드 또는 포그라운드 상태에서 사용자가 푸시 알림을 탭했을 때 호출
    /// push_notification_opened 이벤트가 Amplitude에 정상적으로 로깅됨
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        track(eventName: .pushNotificationOpened)
        
        let userInfo = response.notification.request.content.userInfo
        if let type = userInfo["type"] as? String {
            PushNavigator.handlePush(type: type)
        }
    }
    
    /// 푸시 알림 이벤트 추적: 앱 실행 중(포그라운드) 푸시 수신
    /// 앱이 포그라운드에서 실행 중일 때 푸시 알림을 받으면 호출
    /// push_notification_received 이벤트가 Amplitude에 정상적으로 로깅됨
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        track(eventName: .pushNotificationReceived)
        
        completionHandler([.sound, .banner, .list])
    }
    
    /// error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🟢 [didFailToRegisterForRemoteNotificationsWithError] Error: 발생 ", error)
    }
    
    /// FCM 세팅 메서드
    private func setupFCM(_ application: UIApplication) {
        // Firebase Messaging 설정
        Messaging.messaging().delegate = self
        
        // 푸시 알림 델리게이트 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 권한 요청 및 설정 상태 반영
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { isGranted, error in
            DispatchQueue.main.async {
                if isGranted {
                    print("🔔 알림 허용됨")
                    application.registerForRemoteNotifications()
                } else {
                    print("🚫 알림 거부됨")
                }
                
            }
        }
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🟢 Firebase 등록 토큰(token): \(String(describing: fcmToken))")
        
        guard let fcmToken = fcmToken else { return }

        UserManager.shared.fcmToken = fcmToken
        UserManager.shared.setUserFCMTokenToServer(fcmToken: fcmToken)

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

extension AppDelegate {
    public func track(eventName: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        AmplitudeManager.shared.track(eventType: eventName, eventProperties: eventProperties)
    }
}
