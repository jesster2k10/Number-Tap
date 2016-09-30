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
    func matchReceivedData(_ match: GKMatch, data: Data, fromPlayer player: String)
}

@objc open class GCHelper: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    var authenticationViewController: UIViewController?
    var lastError:Error?
    var gameCenterEnabled: Bool
    var achievements = [String: GKAchievement]()
    
    var delegate: GCHelperDelegate?
    var multiplayerMatch: GKMatch?
    var presentingViewController: UIViewController?
    var multiplayerMatchStarted: Bool
    
    var gcVC: GKGameCenterViewController!
    
    var timer = Timer()
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
        UserDefaults.standard.set(self.gameCenterEnabled, forKey: "gcEnabled")
        FTLogging().FTLog("Local player could not be authenticated, disabling game center")
    }
    
    func wasAuthenticated() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: k.NotificationCenter.Authenticated), object: nil)
        UserDefaults.standard.set(self.gameCenterEnabled, forKey: "gcEnabled")
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkIfAchivement), userInfo: nil, repeats: true)
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
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: PresentAuthenticationViewController), object: self)
            } else if localPlayer.isAuthenticated {
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
    
    func showGameCenter(_ viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        
        let defaults = UserDefaults.standard
        let gc = defaults.bool(forKey: "gcEnabled")
        
        if gc == true {
            gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = viewState
            
            viewController.present(gcVC, animated: true, completion: {
                
                
            })
        } else {
            let alert = UIAlertController(title: "Game Center Unavaliable", message: "Game Center is diabled", preferredStyle: .alert) // 1
            let firstAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                
                NSLog("You pressed button one")
                
            }
            
            alert.addAction(firstAction)
            viewController.present(alert, animated: true, completion:nil) // 6
            
        }
        
    }
    
    func checkIfAchivement() {
        let score = UserDefaults.standard.highScore
        
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
    
    func reportAchievementIdentifier(_ identifier: String, percent: Double) {
        let achievement = GKAchievement(identifier: identifier)
        
        if !achievementIsCompleted(identifier) {
            achievement.percentComplete = percent
            achievement.showsCompletionBanner = true
            
            GKAchievement.report([achievement]) { (error) -> Void in
                guard error == nil else {
                    print("Error in reporting achievements: \(error)")
                    return
                }
            }
        }
    }
    
    open func loadAllAchivements(_ completion: (() -> Void)? = nil) {
        GKAchievement.loadAchievements { (achievements, error) -> Void in
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
    open func achievementIsCompleted(_ identifier: String) -> Bool{
        if let achievement = achievements[identifier] {
            return achievement.percentComplete == 100
        }
        
        return false
    }
    
    /**
     Resets all achievements that have been reported to GameKit.
     */
    open func resetAllAchievements() {
        GKAchievement.resetAchievements { (error) -> Void in
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
    open func reportLeaderboardIdentifier(_ identifier: String, score: Int) {
        let scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        GKScore.report([scoreObject]) { (error) -> Void in
            guard error == nil else {
                print("Error in reporting leaderboard scores: \(error)")
                return
            }
        }
    }
    
    
    // MARK: GameCenter Methods
    
    func showGKGameCenterViewController(_ viewController: UIViewController!) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        // initialize
        let gameCenterViewController = GKGameCenterViewController()
        
        // set the delegate
        gameCenterViewController.gameCenterDelegate = self
        
        // set default view state to Leaderboards
        gameCenterViewController.viewState = .leaderboards
        
        // present controller
        viewController.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    func reportScore(_ score: Int64, forLeaderboardId leaderBoardId: String) {
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
        GKScore.report(scores) { (error) in
            self.lastError = error
        }
    }
    
    // MARK: GameCenter - Multiplayer Methods
    
    func findMatch(_ minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController, delegate: GCHelperDelegate) {
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
        presentingViewController?.present(matchMakerViewController!, animated: true, completion: {
            self.delegate!.foundMatch()
        })
    }
    
    // MARK: GameCenter - GKMatchDelegate Methods
    
    open func match(_ match: GKMatch, didReceive data: Data, fromPlayer playerID: String) {
        if multiplayerMatch != match {
            return
        }
        delegate?.matchReceivedData(match, data: data, fromPlayer: playerID)
    }
    
    open func match(_ match: GKMatch, didFailWithError error: Error?) {
        if multiplayerMatch != match {
            return
        }
        multiplayerMatchStarted = false
        delegate?.matchEnded()
    }
    
    open func match(_ match: GKMatch, player playerID: String, didChange state: GKPlayerConnectionState) {
        if multiplayerMatch != match {
            return
        }
        switch state {
        case .stateConnected:
            print("Player connected")
            if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
                print("Ready to start the match")
                multiplayerMatchStarted = true
                delegate?.matchStarted()
            }
        case .stateDisconnected:
            print("Player disconnected")
            multiplayerMatchStarted = false
            delegate?.matchEnded()
        case .stateUnknown:
            print("Initial player state")
        }
    }
    
    // MARK: GKGameCenterControllerDelegate methods
    
    open func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: GameCenter - GKMatchmakerViewControllerDelegate Methods
    
    open func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.matchEnded()
    }
    
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        presentingViewController?.dismiss(animated: true
            , completion: nil)
        print("Error creating match: \(error.localizedDescription)")
        delegate?.matchEnded()
    }
    
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        GKPlayer.loadPlayers(forIdentifiers: playerIDs) { (players, error) in
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
            GKMatchmaker.shared().finishMatchmaking(for: self.multiplayerMatch!)
            self.delegate?.matchStarted()
            
        }
    }
}
