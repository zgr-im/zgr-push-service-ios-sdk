//
//  Notification+Name.swift
//  Demo Push App
//
//  Created by alex on 14.04.2021.
//

import Foundation

extension Notification.Name {
    static let deviceTokenUpdated = Notification.Name("ZGRDeviceTokenUpdatedNotificationKey")
    static let didReceiveRemoteNotification = Notification.Name("ZGRDidReceiveRemoteNotificationKey")
}
