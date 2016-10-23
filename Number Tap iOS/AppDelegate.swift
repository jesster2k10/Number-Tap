//
//  AppDelegate.swift
//  Universal Game Template
//
//  Created by Matthew Fecher on 12/4/15.
//  Copyright © 2015 Denver Swift Heads. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import iAd
import Firebase
import FirebaseMessaging
import NHNetworkTime
import FBSDKCoreKit
import Appirater

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SupersonicRVDelegate, FYBRewardedVideoControllerDelegate {
    public func supersonicRVAdFailedWithError(_ error: Error!) {
        NSLog("Rewarded video  failed with error \(error.localizedDescription)")
    }

    public func supersonicRVInitFailedWithError(_ error: Error!) {
        NSLog("Rewarded video init failed with error \(error.localizedDescription)")
    }

    var window: UIWindow?
    var type: NotificationType?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            Timer.initArray()
            NHNetworkClock.shared()
            
            //TODO: Delete this
            //UserDefaults.standard.set(0, forKey: kNumbersKey)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.enableDeveloperMode), name: NSNotification.Name(rawValue: "DeveloperMode"), object: nil)
            
            if UserDefaults.isFirstLaunch() || !UserDefaults.keyAlreadyExists("highScore") {
                UserDefaults.standard.highScore = 0
            }
            
            if !UserDefaults.keyAlreadyExists("adsGone") {
                Supersonic.sharedInstance()
                
                let idfv = UUID().uuidString
                Supersonic.sharedInstance().setRVDelegate(self)
                Supersonic.sharedInstance().initRV(withAppKey: "4d9a08fd", withUserId: idfv)
                
                let options = FYBSDKOptions(appId: "63613", securityToken: "ef24a8ba7b89867f306bb9671b8057aa")
                FyberSDK.start(with: options)
                
                UserDefaults.standard.set(0, forKey: "videoSave")
            }
            
            let ln = LocalNotificationHelper.sharedHelper

            for lNotification in UIApplication.shared.scheduledLocalNotifications! {
                if lNotification.alertBody == ln.notificationMessage(.comeBack) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kComeBackNotification), object: nil, userInfo: lNotification.userInfo)
                    UIApplication.shared.cancelLocalNotification(lNotification)
                    break
                };
                
                if lNotification.alertBody == ln.notificationMessage(.dailyReward) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDailyRewardNotification), object: nil, userInfo: lNotification.userInfo)
                    UIApplication.shared.cancelLocalNotification(lNotification)
                    break
                };
                
                if lNotification.alertBody == ln.notificationMessage(.dailyRewardAlmostGone) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDailyRewardAlmostGoneNotification), object: nil, userInfo: lNotification.userInfo)
                    UIApplication.shared.cancelLocalNotification(lNotification)
                    break
                };
                
                if lNotification.alertBody == ln.notificationMessage(.wheelOfFortune) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kWheelOfFortuneNotification), object: nil, userInfo: lNotification.userInfo)
                    UIApplication.shared.cancelLocalNotification(lNotification)
                    break
                }
            }
            
            Appirater.setAppId("1097322101")
            Appirater.setSignificantEventsUntilPrompt(8)
            Appirater.appLaunched(true)
            
            Fabric.sharedSDK().debug = true
            Fabric.with([Crashlytics.self])
            
            FTLogging().setup(true)
            
            if !UserDefaults.keyAlreadyExists(k.isUnlocked.endless) {
                UserDefaults.standard.set(true, forKey: k.isUnlocked.endless)
            }
            
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                FIRApp.configure()
            }
        }
        
        return true
    }

    func loadApp(debugMode debug: Bool, application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        GameModeHelper.sharedHelper.resetPointsCheck()
        
        for lNotification in UIApplication.shared.scheduledLocalNotifications! {
            if lNotification.alertBody == LocalNotificationHelper.sharedHelper.notificationMessage(.comeBack) {
                UIApplication.shared.cancelLocalNotification(lNotification)
                break
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        GameModeHelper.sharedHelper.pausePointsCheck()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day,.month,.year], from: Date())
        
        let randHour = arc4random_uniform(24) + 0
        let randMinute = arc4random_uniform(60) + 0
        let randSecond = arc4random_uniform(60) + 0
        
        components.hour = Int(randHour)
        components.minute = Int(randMinute)
        components.second = Int(randSecond)
        
        let tempDate = calendar.date(from: components)!
        var comps = DateComponents()
        comps.day = 1
        let fireDateOfNotification = (calendar as NSCalendar).date(byAdding: comps, to: tempDate, options:[])
        
        let comeBackMessage = LocalNotificationHelper.sharedHelper.notificationMessage(.comeBack, gameMode: nil)
        LocalNotificationHelper.sharedHelper.scheduleNotificationWith(message: comeBackMessage!, fireDate: fireDateOfNotification!, badgeNumber: 1)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func enableDeveloperMode() {
    }
    
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : Any], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let badgeNumber = application.applicationIconBadgeNumber + 1
        application.applicationIconBadgeNumber = badgeNumber
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: Supersonic ADS :: RVDelegate
    public func supersonicRVInitSuccess() {
        print("Initialised rewarded video")
    }
    
    public func supersonicRVAdAvailabilityChanged(_ hasAvailableAds: Bool) {
        print("Avaliability changed")
    }
    
    public func supersonicRVAdRewarded(_ placementInfo: SupersonicPlacementInfo!) {
        print("Ad Rewarded!")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "videoRewarded"), object: nil, userInfo: ["rewardAmount" : placementInfo.rewardAmount,
            "rewardName"   : placementInfo.rewardName])
    }
    
    public func supersonicRVAdOpened() {
        FTLogging().FTLog("Ad Opened")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "videoOpened"), object: nil)
    }
    
    public func supersonicRVAdClosed() {
        FTLogging().FTLog("Ad closed")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "videoClosed"), object: nil)
    }
    
    public func supersonicRVAdStarted() {
        FTLogging().FTLog("Ad Started")
    }
    
    public func supersonicRVAdEnded() {
        FTLogging().FTLog("Ad Ended")
    }
    
    func rewardedVideoControllerDidStartVideo(_ rewardedVideoController: FYBRewardedVideoController!) {
        print("Started Rewarded Video")
    }
    
    func rewardedVideoControllerDidReceiveVideo(_ rewardedVideoController: FYBRewardedVideoController!) {
        print("Received Video")
        let vc = self.window?.rootViewController
        rewardedVideoController.presentRewardedVideo(from: vc!)
    }
    
    func rewardedVideoController(_ rewardedVideoController: FYBRewardedVideoController!, didDismissVideoWith reason: FYBRewardedVideoControllerDismissReason) {
        switch reason {
        case FYBRewardedVideoControllerDismissReason.error:
            print("Error during playback")
            break;
            
        case FYBRewardedVideoControllerDismissReason.userEngaged:
            print("User was engaged")
            break;
            
        case FYBRewardedVideoControllerDismissReason.aborted:
            print("User aborted video")
            break;
        }
    }
    
    func rewardedVideoController(_ rewardedVideoController: FYBRewardedVideoController!, didFailToStartVideoWithError error: Error!) {
        print("Failed to start video: \(error.localizedDescription)")
    }
    
    //MARK: Notification
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        if notification.alertBody == LocalNotificationHelper.sharedHelper.notificationMessage(.comeBack) {
            let pointsAdded = 5
            let defaults = UserDefaults.standard
            let oldScore = defaults.integer(forKey: "score")
            let newScore = oldScore + pointsAdded
            
            defaults.set(newScore, forKey: "score")
            
            //TODO: Add a toast or something to show the added coins.
        } else {
            LocalNotificationHelper.sharedHelper.notificationReceivedWhileInApp(notification: notification)
        }
    }
    
    @available(iOS 9.0, *)
    private func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "com.flatboxstudio.numbertap.open-endless" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "sceneSet"), object: nil)
        }
    }


}

