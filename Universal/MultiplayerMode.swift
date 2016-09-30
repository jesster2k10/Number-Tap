//
//  MultiplayerMode.swift
//  Number Tap
//
//  Created by Jesse on 11/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import GameKit
import MBProgressHUD

let kHasPlayedMultiplayer = "playedMultiplayer"

class MultiplayerMode : BaseScene, MultiplayerNetworkingProtocol {
    public func receivedElements(_ array: [Any]!, startingNumber num: Int32) {
        if let arr = array as? [Int] {
            self.array = arr
            self.number = Int(num)
        }
    }

    public func getNumber(_ array: [Any]!) {
        
    }

    var gameOverBlock:((Bool)->Void)!
    var gameEndedBlock:(()->Void)!
    var networkingEngine : MultiplayerNetworking!
    var didWin = false
    var aindex = 0
    
    var alert : PMAlertController!
    var blurView : UIVisualEffectView!
    var blurEffect : UIBlurEffect!
    var progress : MBProgressHUD!
    
    override func didMove(to view: SKView) {
        randomWord()
        start(.kMultiplayer, cam: nil)
        
        if !UserDefaults.keyAlreadyExists(kHasPlayedMultiplayer) {
    
            alert = PMAlertController(title: "Welcome to Multiplayer!", description: "Multiplayer in Number Tap! allows you to share the fun with friends, family or even strangers! \r\n\r\nThe first person to tap the number, get's the point! Simple as. Beat the clock, beat your opponent. \r\n\r\nThe person who tapped the most numbers wins!", image: nil, style: .alertWithBlur)
            
            let okAction = PMAlertAction(title: "Let's Go!", style: .default) {
                print("Selected ok!")
                self.begin()
            }
            
            let cancelAction = PMAlertAction(title: "Nah..", style: .cancel) {
                print("selected cancel")
                
                let gameModes = GameModes()
                self.view?.presentScene(gameModes, transition: SKTransition.crossFade(withDuration: 1))
                self.removeFromParent()
                self.removeAllChildren()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            let vc = self.view?.window?.rootViewController
            vc!.present(alert, animated: true, completion: nil)
            
            //KeychainWrapper.defaultKeychainWrapper().setBool(true, forKey: kHasPlayedMultiplayer)
        } else {
            begin()
        }
        
    }
    
    func begin() {
        self.blurEffect = UIBlurEffect(style: .dark)
        self.blurView = UIVisualEffectView(effect: self.blurEffect)
        
        self.blurView.frame = view!.bounds
        self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view!.insertSubview(self.blurView, aboveSubview: self.view!)
        print("Added Blur")
        
        self.progress = MBProgressHUD.showAdded(to: view!, animated: true)
        self.progress.mode = .indeterminate
        self.progress.label.text = "Checking for WiFi Connection..."
        
        if Reachability.isConnectedToNetwork() == true {
            self.progress.label.text = "Starting Game Center"
            
            let key = UserDefaults.standard.bool(forKey: "gcEnabled")
            
            if key == true {
                self.setupMultiplayer()
            } else {
                let vc = self.view!.window?.rootViewController
                self.showAuthenticatedVC(vc!)
            }
            
        } else {
            self.showWifiAlert()
        }

    }
    
    func showAuthenticatedVC(_ vc: UIViewController) {
        let gameKitHelper = GCHelper.sharedGameKitHelper
        vc.present(gameKitHelper.authenticationViewController!, animated: true, completion: {
            self.check()
        })
    }
    
    func check() {
        let vc = self.view!.window?.rootViewController

        let key = UserDefaults.standard.bool(forKey: "gcEnabled")
        if key {
            self.setupMultiplayer()
        } else {
            let alert = PMAlertController(title: "Error", description: "Please enable/login to GameCenter to continue", image: nil, style: .alertWithBlur)
            alert.addAction(PMAlertAction(title: "Try Again", style: .default, action: {
                let vc = self.view!.window?.rootViewController
                self.showAuthenticatedVC(vc!)
            }))
            
            alert.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
                UIView.animate(withDuration: 1) {
                    self.blurView.alpha = 0
                    self.blurView.removeFromSuperview()
                }
                
                let gameModes = GameModes()
                self.view?.presentScene(gameModes, transition: SKTransition.crossFade(withDuration: 1))
                self.removeFromParent()
                self.removeAllChildren()
                
                MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)

            }))
            
            vc!.present(alert, animated: true, completion: nil)
        }
        
        
        self.tryStartGame()
    }
    
    @objc func setupMultiplayer() {
        print("start :)")
        gameEndedBlock = { () -> Void in
            
        }
        
        gameOverBlock = { (didWin) -> Void in
            self.gameOver(didWin)
        }
        
        networkingEngine = MultiplayerNetworking()
        networkingEngine.delegate = self
        
        progress.label.text = "Checking for wifi connection"
        
        tryStartGame()
    }
    
    func tryStartGame() {
        Timer.after(0) {
            if Reachability.isConnectedToNetwork() {
                self.progress.label.text = "Starting Multiplayer Game"
                self.playerAuthenticated()
            } else {
                self.progress.label.text = "Failed to find WiFi Network"
                Timer.after(2, {
                    self.showWifiAlert()
                })
            }
        }
    }
    
    func showWifiAlert()  {
        let vc = self.view!.window!.rootViewController!

        let wifiAlert = PMAlertController(title: "No Wifi Connection", description: "Unfortunately, our robots were unable to start your game as it appears you are not connected to WiFi. All multiplayer games need a WiFi connection.", image: nil, style: .alertWithBlur)
        wifiAlert.addAction(PMAlertAction(title: "Retry", style: .default, action: { 
            self.tryStartGame()
        }))
        
        wifiAlert.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
            MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)
            
            UIView.animate(withDuration: 1) {
                self.blurView.alpha = 0
                self.blurView.removeFromSuperview()
            }
            
            let gameModes = GameModes()
            self.view?.presentScene(gameModes, transition: SKTransition.crossFade(withDuration: 1))
            self.removeFromParent()
            self.removeAllChildren()
        }))
        
        vc.present(wifiAlert, animated: true, completion: nil)
    }
    
    func playerAuthenticated() {
        let vc = self.view!.window!.rootViewController!
        print("start :)")
        
        GameKitHelper.shared().findMatch(withMinPlayers: 2, maxPlayers: 2, viewController: vc, delegate: networkingEngine)
    }
    
    func setCurrentPlayerIndex(_ index: UInt) {
        aindex = Int(index)
    }
    
    func foundMatch() {
        UIView.animate(withDuration: 1) {
            self.blurView.alpha = 0
            self.blurView.removeFromSuperview()
        }
        
        MBProgressHUD.hideAllHUDs(for: view!, animated: true)
    }
    
    //MARK : MultiplayerNetworkingProtocol
    @objc func matchEnded() {
        if (self.gameEndedBlock != nil) {
            self.gameOverBlock(didWin)
        }
    }
    
    @objc func getNumber(_ array: [AnyObject]!) {
        if let arr = array as? [Int] {
            print(arr)
        }
    }
    
    @objc func matchStarted() {
        randomWord()
        networkingEngine.send(array)
        
        start(kGameMode.kMultiplayer, cam: nil)
    }
    
    @objc func gameBegan() {
        print("Game Began")
        
        let alert = UIAlertController(title: "Game Begab!", message:"Yes!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay.", style: .default) { _ in })
        
        let vc = self.view?.window?.rootViewController!
        vc?.present(alert, animated: true, completion: nil)
    }
    
    @objc func point() {
        print("Point!")
        numbersTapped += 1
        
        updateScore(numbersTapped)
        
        let alert = UIAlertController(title: "Point!", message:"Yes!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay.", style: .default) { _ in })
        
        let vc = self.view?.window?.rootViewController!
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func resetTimer() {
        
    }
    
    func gameOver(_ player1Won: Bool) {
        
    }
    
    func newNumber(_ number: Int32) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        networkingEngine.sendPoint()
    }
    
}
