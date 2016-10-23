//
//  GameModeHelper.swift
//  Number Tap Universal
//
//  Created by Jesse on 23/09/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

import Foundation
import UIKit

let kLevelUnlockedNotificationName = "unlocked"
let kPlayGameModeNotification = "playGameMode"

class GameModeHelper {
    var pointsCheckTimer = Timer()
    var isTimerActive = false

    enum kGameMode {
        case Easy, Medium, Impossible, Endless, Memory, Multiplayer, Shoot
    }
    
    static let sharedHelper : GameModeHelper = {
        let instance = GameModeHelper()
        return instance
    }()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(levelUnlocked(notification:)), name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil)

    }
    
    @objc func levelUnlocked(notification: NSNotification) {
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject> {
            if let level = userInfo["level"] as? String {
                showUnlockedNotification(level: level, count: 0)
            }
        }
    }
    
    func showUnlockedNotification(level: String, count : Int) {
        let title = "New Mode Unlocked!"
        let desc = getUnlockedText(mode: level)
        
        UserDefaults.standard.set(true, forKey: level)
        
        let notification = PMAlertController(title: title, description: desc, image: nil, style: .walkthroughWithBlur)
        let playAction = PMAlertAction(title: "Play Now!", style: .default) {
            //TODO: Play Game Mode
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayGameModeNotification), object: nil)
        }
        
        let laterAction = PMAlertAction(title: "Later", style: .cancel) {
            //TODO: Schedule local notification to alert user after 15, 30, 60 minutes
            if count == 0 {
                let message = LocalNotificationHelper.sharedHelper.notificationMessage(.gameModeUnlocked, gameMode: level)
                LocalNotificationHelper.sharedHelper.scheduleNotificationWith(message: message!, intervalInSeconds: 54000, badgeNumber: 1)
            }
        }
        
        let idk = PMAlertAction(title: "I Dont Care..", style: .cancel)
        
        notification.addAction(playAction)
        notification.addAction(laterAction)
        notification.addAction(idk)
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let rootVC = appDelegate.window!.rootViewController
        
        rootVC?.present(notification, animated: true, completion: nil)
    }
    
    func getUnlockedText(mode: String) -> String {
        return "New Game Mode has been unlocked! Are you ready to play \(mode) mode?"
    }
    
    func modeIsUnlocked(_ mode: String) -> Bool {
        if !UserDefaults.keyAlreadyExists(mode) {
            return false
        }
        
        return true
    }

}

extension GameModeHelper {
    func initPointsCheck() {
        isTimerActive = true
        pointsCheckTimer = Timer.every(0.01) {
            let numbersTapped = UserDefaults.standard.integer(forKey: kNumbersKey)
            
            if numbersTapped >= k.numbersToUnlock.easy && !self.modeIsUnlocked(kEasyGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level": kEasyGameMode])

            } else if numbersTapped >= k.numbersToUnlock.shuffle && !self.modeIsUnlocked(kShuffleGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kShuffleGameMode, userInfo: ["level": kShuffleGameMode])
                
            } else if numbersTapped >= k.numbersToUnlock.hard && !self.modeIsUnlocked(kImpossibleGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kImpossibleGameMode, userInfo: ["level": kImpossibleGameMode])
                
            } else if numbersTapped >= k.numbersToUnlock.shoot && !self.modeIsUnlocked(kShootGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kShootGameMode, userInfo: ["level": kShootGameMode])
                
            } else if numbersTapped >= k.numbersToUnlock.memory && !self.modeIsUnlocked(kMemoryGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kMemoryGameMode, userInfo: ["level": kMemoryGameMode])
                
            } else if numbersTapped >= k.numbersToUnlock.buildUp && !self.modeIsUnlocked(kBuildUpGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kBuildUpGameMode, userInfo: ["level": kBuildUpGameMode])
                
            } else if numbersTapped >= k.numbersToUnlock.multiplayer && !self.modeIsUnlocked(kMultiplayerGameMode) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: kMultiplayerGameMode, userInfo: ["level": kMultiplayerGameMode])
                
            }
            
            /*switch numbersTapped {
            case  k.numbersToUnlock.easy:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level"
                    
                    : kEasyGameMode])
            case k.numbersToUnlock.medium:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level" : kMediumGameMode])
            case k.numbersToUnlock.hard:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level" : kImpossibleGameMode])
            case k.numbersToUnlock.shoot:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level" : kShootGameMode])
            case k.numbersToUnlock.memory:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level": kMemoryGameMode])
            case k.numbersToUnlock.buildUp:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level" : kBuildUpGameMode])
            case k.numbersToUnlock.multiplayer:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLevelUnlockedNotificationName), object: nil, userInfo: ["level" : kMultiplayerGameMode])
            default:
                break;
            }*/
        }
    }
    
    func pausePointsCheck() {
        pointsCheckTimer.invalidate()
        isTimerActive = false
    }
    
    func resetPointsCheck() {
        if !isTimerActive {
            pointsCheckTimer.fire()
            isTimerActive = true
        }
    }
    
    func getTimerState() -> Bool {
        return isTimerActive
    }
}
