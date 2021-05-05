//
//  NotificationViewController.swift
//  notification-content
//
//  Created by alex on 14.04.2021.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import ZGRImSDK

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    override func viewDidLoad() {
        super.viewDidLoad()
        ZGRNotificationContent.sharedInstance().didLoad(view)
    }
    
    func didReceive(_ notification: UNNotification) {
        ZGRNotificationContent.sharedInstance().didReceive(notification)
    }

}
