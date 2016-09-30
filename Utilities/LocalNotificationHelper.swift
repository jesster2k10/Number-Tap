//
//  LocalNotificationHelper.swift
//  Number Tap Universal
//
//  Created by Jesse on 23/09/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

import Foundation

public enum NotificationType {
    case comeBack
    case waited
    case dailyReward
    case dailyRewardAlmostGone
    case wheelOfFortune
    case gameModeUnlocked
}

class LocalNotificationHelper : NSObject {
    static let sharedHelper : LocalNotificationHelper = {
        let instance = LocalNotificationHelper()
        return instance
    }()
    
    func scheduleNotificationWith(message: String, intervalInSeconds: TimeInterval, badgeNumber: Int) {
        // 1 Create empty notification
        let localNotification = UILocalNotification()
        
        // 2 Calculate notification time using NSDate
        let now = NSDate()
        let notificationTime = now.addingTimeInterval(intervalInSeconds)
        
        // 3 Set properties of your notification
        localNotification.alertBody = message
        localNotification.fireDate = notificationTime as Date
        localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = badgeNumber
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        // 4 Schedule the notification
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func scheduleNotificationWith(message: String, fireDate: Date, badgeNumber: Int) {
        // 1 Create empty notification
        let localNotification = UILocalNotification()
        
        // 3 Set properties of your notification
        localNotification.alertBody = message
        localNotification.fireDate = fireDate
        localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = badgeNumber
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        // 4 Schedule the notification
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func notificationMessage(_ type: NotificationType, gameMode: String? = nil) -> String? {
        switch type {
            
        case .comeBack:
            return "Come back! It's been a while, there's still numbers to tap"
        case .waited:
            return "Your time has been set back and it's time to play"
        case .dailyReward:
            return "Hey, Your daily reward is now available! Come get it before it's too late"
        case .dailyRewardAlmostGone:
            return "Come quick! Your reward is almost gone!"
        case .wheelOfFortune:
            return "You received a free spin on the wheel of fortune!"
        case .gameModeUnlocked:
            return "Don't forget to check out the \(gameMode!) game mode!"
        }
    }
    
    func notificationReceivedWhileInApp(notification: UILocalNotification) {
        if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kEasyGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kEasyGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kMediumGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kMediumGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kImpossibleGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kImpossibleGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kShootGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kShootGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kMemoryGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kMemoryGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kBuildUpGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kBuildUpGameMode, count: 1)
        } else if notification.alertBody == notificationMessage(.gameModeUnlocked, gameMode: kMultiplayerGameMode) {
            GameModeHelper.sharedHelper.showUnlockedNotification(level: kMultiplayerGameMode, count: 1)
        }
    }
}
