//
//  GCHelper.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import GameKit
import Foundation

let singleton = GCHelper()
let PresentAuthenticationViewController = "PresentAuthenticationViewController"

@objc protocol GCHelperDelegate {
    func foundMatch()
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: String)
}

@objc public class GCHelper: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    var authenticationViewController: UIViewController?
    var lastError:NSError?
    var gameCenterEnabled: Bool
    var achievements = [String: GKAchievement]()
    
    var delegate: GCHelperDelegate?
    var multiplayerMatch: GKMatch?
    var presentingViewController: UIViewController?
    var multiplayerMatchStarted: Bool
    
    var gcVC: GKGameCenterViewController!
    
    var timer = NSTimer()
    var playersDict = [String: AnyObject]()
    
    class var sharedGameKitHelper: GCHelper {
        return singleton
    }
    
    override init() {
        gameCenterEnabled = true
        multiplayerMatchStarted = false
        super.init()
    }
    
    func wasNotAuthenticated() {
        NSUserDefaults.standardUserDefaults().setBool(self.gameCenterEnabled, forKey: "gcEnabled")
        FTLogging().FTLog("Local player could not be authenticated, disabling game center")
    }
    
    func wasAuthenticated() {
        NSNotificationCenter.defaultCenter().postNotificationName(k.NotificationCenter.Authenticated, object: nil)
        NSUserDefaults.standardUserDefaults().setBool(self.gameCenterEnabled, forKey: "gcEnabled")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.checkIfAchivement), userInfo: nil, repeats: true)
        print("Authenticated!")
        
    }
    
    func authenticateLocalPlayer() {
        //
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) in
            // store any error in local variable
            self.lastError = error
            
            if viewController != nil {
                // if user hasnt logged into game center show game center login controller
                self.authenticationViewController = viewController
                
                NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
            } else if localPlayer.authenticated {
                // if logged in
                self.gameCenterEnabled = true
                NSLog("Authenticated")
                self.wasAuthenticated()
            } else {
                // not logged in
                self.gameCenterEnabled = false
                self.wasNotAuthenticated()
            }
        }
    }
    
    func showGameCenter(viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let gc = defaults.boolForKey("gcEnabled")
        
        if gc == true {
            gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = viewState
            
            viewController.presentViewController(gcVC, animated: true, completion: {
                
                
            })
        } else {
            let alert = UIAlertController(title: "Game Center Unavaliable", message: "Game Center is diabled", preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in
                
                NSLog("You pressed button one")
                
            }
            
            alert.addAction(firstAction)
            viewController.presentViewController(alert, animated: true, completion:nil) // 6
            
        }
        
    }
    
    func checkIfAchivement() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let score = defaults.integerForKey("highScore")
        
        if score == 100 || score < 100 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points100, percent: 100.0)
        }
            
        else if score == 500 || score < 500 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points500, percent: 100.0)
        }
            
        else if score == 1000 || score < 1000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points1k, percent: 100.0)
        }
            
        else if score == 10000 || score < 10000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points10k, percent: 100.0)
        }
            
        else if score == 50000 || score < 50000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points50k, percent: 100.0)
        }
            
        else if score == 100000 || score < 10000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points100k, percent: 100.0)
        }
            
        else if score == 500000 || score < 500000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points500k, percent: 100.0)
        }
            
        else if score == 1000000 || score < 100000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points1M, percent: 100.0)
        }
        
    }
    
    func reportAchievementIdentifier(identifier: String, percent: Double) {
        let achievement = GKAchievement(identifier: identifier)
        
        if !achievementIsCompleted(identifier) {
            achievement.percentComplete = percent
            achievement.showsCompletionBanner = true
            
            GKAchievement.reportAchievements([achievement]) { (error) -> Void in
                guard error == nil else {
                    print("Error in reporting achievements: \(error)")
                    return
                }
            }
        }
    }
    
    public func loadAllAchivements(completion: (() -> Void)? = nil) {
        GKAchievement.loadAchievementsWithCompletionHandler { (achievements, error) -> Void in
            guard error == nil, let achievements = achievements else {
                print("Error in loading achievements: \(error)")
                return
            }
            
            for achievement in achievements {
                if let id = achievement.identifier {
                    self.achievements[id] = achievement
                }
            }
            
            completion?()
        }
    }
    
    /**
     Checks if an achievement in allPossibleAchievements is already 100% completed
     
     :param: identifier A string that matches the identifier string used to create an achievement in iTunes Connect.
     */
    public func achievementIsCompleted(identifier: String) -> Bool{
        if let achievement = achievements[identifier] {
            return achievement.percentComplete == 100
        }
        
        return false
    }
    
    /**
     Resets all achievements that have been reported to GameKit.
     */
    public func resetAllAchievements() {
        GKAchievement.resetAchievementsWithCompletionHandler { (error) -> Void in
            guard error == nil else {
                print("Error resetting achievements: \(error)")
                return
            }
        }
    }
    
    /**
     Reports a high score eligible for placement on a leaderboard to GameKit.
     
     :param: identifier A string that matches the identifier string used to create a leaderboard in iTunes Connect.
     :param: score The score earned by the user.
     */
    public func reportLeaderboardIdentifier(identifier: String, score: Int) {
        let scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        GKScore.reportScores([scoreObject]) { (error) -> Void in
            guard error == nil else {
                print("Error in reporting leaderboard scores: \(error)")
                return
            }
        }
    }
    
    
    // MARK: GameCenter Methods
    
    func showGKGameCenterViewController(viewController: UIViewController!) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        // initialize
        let gameCenterViewController = GKGameCenterViewController()
        
        // set the delegate
        gameCenterViewController.gameCenterDelegate = self
        
        // set default view state to Leaderboards
        gameCenterViewController.viewState = .Leaderboards
        
        // present controller
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func reportScore(score: Int64, forLeaderboardId leaderBoardId: String) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        // GameCenter expects scores to be a GKScore object.
        let scoreReporter = GKScore(leaderboardIdentifier: leaderBoardId)
        scoreReporter.value = score
        scoreReporter.context = 0
        
        let scores = [scoreReporter]
        
        // This code calls the completion handler when Game Center is done processing the scores, and again, this method takes care of auto-sensing scores on network failures.
        GKScore.reportScores(scores) { (error) in
            self.lastError = error
        }
    }
    
    // MARK: GameCenter - Multiplayer Methods
    
    func findMatch(minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController, delegate: GCHelperDelegate) {
        // exit if player is not authenticated
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        NSLog("Finding MAtch...")
        
        // if authenticated set variables
        multiplayerMatchStarted = false
        multiplayerMatch = nil
        self.delegate = delegate
        presentingViewController = viewController
        
        // create a request with the appropriate criteria
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        
        //
        let matchMakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
        matchMakerViewController!.matchmakerDelegate = self
        presentingViewController?.presentViewController(matchMakerViewController!, animated: true, completion: {
            self.delegate!.foundMatch()
        })
    }
    
    // MARK: GameCenter - GKMatchDelegate Methods
    
    public func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        if multiplayerMatch != match {
            return
        }
        delegate?.matchReceivedData(match, data: data, fromPlayer: playerID)
    }
    
    public func match(match: GKMatch, didFailWithError error: NSError?) {
        if multiplayerMatch != match {
            return
        }
        multiplayerMatchStarted = false
        delegate?.matchEnded()
    }
    
    public func match(match: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        if multiplayerMatch != match {
            return
        }
        switch state {
        case .StateConnected:
            print("Player connected")
            if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
                print("Ready to start the match")
                multiplayerMatchStarted = true
                delegate?.matchStarted()
            }
        case .StateDisconnected:
            print("Player disconnected")
            multiplayerMatchStarted = false
            delegate?.matchEnded()
        case .StateUnknown:
            print("Initial player state")
        }
    }
    
    // MARK: GKGameCenterControllerDelegate methods
    
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: GameCenter - GKMatchmakerViewControllerDelegate Methods
    
    public func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.matchEnded()
    }
    
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        presentingViewController?.dismissViewControllerAnimated(true
            , completion: nil)
        print("Error creating match: \(error.localizedDescription)")
        delegate?.matchEnded()
    }
    
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        multiplayerMatch = match
        multiplayerMatch!.delegate = self
        
        if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
            print("Ready to start the match")
            lookUpPlayers()
        }
    }
    
    func lookUpPlayers() {
        let playerIDs = multiplayerMatch?.players.map { $0.playerID } as! [String]
        
        print("Looking up players %@", playerIDs)
        
        GKPlayer.loadPlayersForIdentifiers(playerIDs) { (players, error) in
            guard error == nil else {
                print("Error retreving player info: %@", error?.localizedDescription)
                self.multiplayerMatchStarted = false
                self.delegate?.matchEnded()
                return
            }
            
            guard let players = players else {
                print("Error retreving players; returned nil")
                return
            }
            
            for player in players {
                print("Found player: %@", player.alias)
                self.playersDict[player.playerID!] = player
            }
            
            self.multiplayerMatchStarted = true
            GKMatchmaker.sharedMatchmaker().finishMatchmakingForMatch(self.multiplayerMatch!)
            self.delegate?.matchStarted()
            
        }
    }
}
