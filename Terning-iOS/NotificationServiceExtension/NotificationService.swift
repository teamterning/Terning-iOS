//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 이명진 on 5/1/25.
//

import UserNotifications
import AmplitudeSwift

// Push 알림 Attachment 에 Image 를 넣기 위해 구현
final class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    // Extension용 Amplitude 인스턴스
    private let amplitude = Amplitude(configuration: Configuration(apiKey: SharedConfig.AMPLITUDE_API_KEY))
    
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // 📱 푸시 알림 이벤트 추적: 앱 종료 상태에서 푸시 수신
        // ✅ 앱이 완전히 종료된 상태에서 푸시 알림을 받을 때 NotificationServiceExtension이 실행되어 호출
        // ✅ push_notification_received 이벤트가 Amplitude에 정상적으로 로깅됨
        // ✅ public AmplitudeManager.shared 사용으로 메인 앱과 통일된 로깅
        track(eventName: .pushNotificationReceived)
        
        guard let bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        // 🔍 imageUrl 필드 사용
        if let imageURLString = request.content.userInfo["imageUrl"] as? String,
           let imageURL = URL(string: imageURLString) {
            downloadImage(from: imageURL) { attachment in
                if let attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        } else {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL, error == nil else {
                completion(nil)
                return
            }
            
            let fileManager = FileManager.default
            let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueURL = tmpDir.appendingPathComponent(UUID().uuidString + ".jpg")
            
            do {
                try fileManager.moveItem(at: tempURL, to: uniqueURL)
                let attachment = try UNNotificationAttachment(identifier: "image", url: uniqueURL, options: [:])
                completion(attachment)
            } catch {
                print("❌ 이미지 첨부 실패: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

// MARK: - Amplitude Tracking Extension
extension NotificationService {
    private func track(eventName: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        // Extension용 독립적인 Amplitude 인스턴스 사용
        // 메인 앱과 동일한 API 키를 사용하므로 Amplitude 대시보드에서는 통합되어 보임
        amplitude.track(eventType: eventName.rawValue, eventProperties: eventProperties)
    }
}
