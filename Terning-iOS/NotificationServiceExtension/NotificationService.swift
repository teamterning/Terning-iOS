//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 이명진 on 5/1/25.
//

import UserNotifications

// Push 알림 Attachment 에 Image 를 넣기 위해 구현
final class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
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
                let attachment = try UNNotificationAttachment(identifier: "image", url: uniqueURL, options: nil)
                completion(attachment)
            } catch {
                print("❌ 이미지 첨부 실패: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
