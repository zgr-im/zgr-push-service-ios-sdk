//
//  NotificationService.swift
//  notification-service
//
//  Created by alex on 14.04.2021.
//

import UserNotifications
import ZGRImSDK

final class NotificationService: ZGRNotificationService {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        print("NotificationService.didReceive called. request = \(request)")
        super.didReceive(request, withContentHandler: contentHandler)
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "Ok, my own method"
            bestAttemptContent.body = "Not handled by ZGR"
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        super.serviceExtensionTimeWillExpire()
    }

}
