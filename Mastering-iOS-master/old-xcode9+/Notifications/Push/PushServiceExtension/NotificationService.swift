//
//  NotificationService.swift
//  PushServiceExtension
//
//  Created by 김주협 on 2020/12/11.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            if let str = bestAttemptContent.userInfo["url"] as? String, let url = URL(string: str) {
                let tempFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent("img")
                
                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: tempFileUrl)
                    
                    let imageAttachment = try UNNotificationAttachment(identifier: "img", url: tempFileUrl, options: [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG])
                    bestAttemptContent.attachments = [imageAttachment]
                }catch {
                    bestAttemptContent.body = "\(bestAttemptContent.body)\n\(error.localizedDescription)"
                }
                
                if let str = bestAttemptContent.userInfo["enc-data"] as? String, let data = Data(base64Encoded: str) {
                    bestAttemptContent.title = String(data: data, encoding: .utf8) ?? "[Encrypted]"
                }else {
                    bestAttemptContent.title = "[Encrypted]"
                }
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
