//
//  AppDelegate.swift
//  Demo Push App
//
//  Created by alex on 13.04.2021.
//

import UIKit
import UserNotifications
import ZGRImSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public var deviceToken: Data?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }

        ZGRMessaging.sharedInstance().deviceId = nil
        ZGRMessaging.sharedInstance().isLocalDatabaseEnabled = true
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ZGRMessaging.sharedInstance().register(forRemoteNotifications: deviceToken)
        self.deviceToken = deviceToken
         
        let center = NotificationCenter.default
        center.post(name: .deviceTokenUpdated, object: self, userInfo: ["deviceToken": deviceToken])
        center.addObserver(self, selector: #selector(handleDidReceivePushNotification), name: .didReceiveRemoteNotification, object: nil)
    }
    
    @objc func handleDidReceivePushNotification(_ notif: Notification) {
        print(" ----->>> handleDidReceivePushNotification called. params = \(notif)")
    }
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // MARK: Here you will receive silent and VOIP push notification
        if (!ZGRMessaging.sharedInstance().application(application, didReceiveRemoteNotification: userInfo) { _ in
            // Handle remote notification from ZGR
        }) {
            // Handle foreign remote notification
        }
        completionHandler(.noData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
     
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // MARK: You should know that when app in opened state, notification will be silenced by default cause of implicit completionHandler(UNNotificationPresentationOptionNone) call
        completionHandler(.list) // .alert
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // MARK: User responded to notification
        if (!ZGRMessaging.sharedInstance().userNotificationCenter(center, didReceive: response) { notification, action in // [weak self]
            // Handle notification from ZGR
            
            // User clicked notification content
            if (action.type == .default) {
                // Perform any code
            }
            
            // User clicked custom button under notification content
            if (action.type == .other) {
                let actionId = action.identifier
                if actionId.count > 0 {
                    print("User did select custom action with Id: \(actionId)")
                }
            }
            
            // Optional data for your's own purposes
//            if let customPayload = notification.customPayload as? AnyObject {
//                self?.window?.rootViewController?.ext_showAlertWithTitle("Custom payload", message: customPayload.description ?? "")
//            }
            
        }) {
            // Handle foreign notification
        }
        
        completionHandler()
    }
}
