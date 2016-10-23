
//
//  Constants.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

let kIsAppLive = false
let kPausedNotification = "gamePaused"
let kUnPausedNotification = "gameUnpaused"

let kComeBackNotification = "comeBack"
let kDailyRewardNotification = "dailyReward"
let kDailyRewardAlmostGoneNotification = "almostGone"
let kWheelOfFortuneNotification = "wheel"

let kEndlessGameMode = "Endless"
let kEasyGameMode = "Easy"
let kShuffleGameMode = "Shuffle"
let kImpossibleGameMode = "Impossible"
let kShootGameMode = "Shoot"
let kMemoryGameMode = "Memory"
let kMultiplayerGameMode = "Multiplayer"
let kBuildUpGameMode = "Build Up"

enum gameMode: String {
    case Timed   = "Timed"
    case Endless = "Endless"
    case Memory  = "Memory"
    case FirstLaunch = "First Launch"
    case Easy = "Easy"
    case Impossible = "Impossible"
}

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum Products {
    
    fileprivate static let Prefix = "com.flatboxstudio.numbertap."
    
    /// MARK: - Supported Product Identifiers
    public static let RemoveAds           = Prefix + "removeAds"
    public static let UnlockAllLevel      = Prefix + "unlockAllLevels"
    
    // All of the products assembled into a set of product identifiers.
    public static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds, Products.UnlockAllLevel]
    
    /// Static instance of IAPHelper that for rage products.
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

struct k {
    
    fileprivate static let Prefix    = "com.flatboxstudio.numbertap."
    fileprivate static let wavEnding = ".wav"
    fileprivate static let MontserratPrefix = "Montserrat"
    
    struct isUnlocked {
        static let shoot = "Shoot"
        static let endless = "Endlesss"
        static let memory = "Memory"
        static let multiplayer = "Multiplayer"
        static let easy = "Easy"
        static let hard = "Impossible"
        static let buildUp = "Build Up"
        static let shuffle = "Shuffle"
    }
    
    struct numbersToUnlock {
        static let shoot = 400
        static let endless = 0
        static let memory = 900
        static let multiplayer = 1450
        static let easy = 200
        static let shuffle = 250
        static let hard = 300
        static let buildUp = 1150
    }
    
    struct Montserrat {
        static let Regular = MontserratPrefix + "-Regular"
        static let SemiBold = MontserratPrefix + "-SemiBold"
        static let Light = MontserratPrefix + "-Light"
        static let UltraLight = MontserratPrefix + "-UltraLight"
        static let Hairline = MontserratPrefix + "-Harline"
    }
    
    struct NotificationCenter {
        static let shootScore = "shootScore"
        static let Counter = "counter"
        static let Authenticated = "authenticated"
        static let RecordGameplay = "gameplay"
    }
    
    struct keys {
        
        static let cbAppId        = "56f6fd9c5b14536f8a31e503"
        static let cbAppSignature = "720d055366d319187a7ea370039704f5139c237f"
        static let ADAppID        = "appfd40158c251440d3a1"
        static let ADZoneIDs      = ["vze3c2eb0db7f0404eac"]
    }
    
    struct Sounds {
        
        static let blop01      = "blop01" + wavEnding
        static let blop02      = "blop02" + wavEnding
        
        static let blipBlop    = "blipBlop" + wavEnding
        
        static let blopAction1 = SKAction.playSoundFileNamed(blop01, waitForCompletion: false)
        static let blopAction2 = SKAction.playSoundFileNamed(blop02, waitForCompletion: false)
    }
    
    struct flatColors {
        static let red = UIColor(rgba: "#e74c3c")
    }
    
    struct GameCenter {
        struct Leaderboard {
            
            static let TopScorers    = Prefix + "top_scorers"
            static let ShortestTimes = Prefix + "shortest_times"
            static let LongestRound  = Prefix + "longest_rounds"
            
        }
        
        struct Achivements {
            
            static let Points100  = Prefix + "100"
            static let Points500  = Prefix + "500"
            static let Points1k   = Prefix + "1000"
            static let Points10k  = Prefix + "10k"
            static let Points50k  = Prefix + "50k"
            static let Points100k = Prefix + "100k"
            static let Points500k = Prefix + "500k"
            static let Points1M   = Prefix + "1million"
            
        }
    }
}
