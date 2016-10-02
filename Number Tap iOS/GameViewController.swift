//
//  GameViewController.swift
//  Universal Game Template
//
//  Created by Matthew Fecher on 12/4/15.
//  Copyright (c) 2015 Denver Swift Heads. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    var backgroundMusicPlayer = AVAudioPlayer()
    var skView: SKView = SKView()
    var counterLabel = UILabel()
    var pauseLabel = UILabel()
    var pausedTimer = Timer()
    var blurView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()

        var scene = SKScene()
        
        if UserDefaults.isFirstLaunch() {
            scene = TutorialScene()
        } else {
            scene = HomeScene()
        }
        
        // Configure the view.
        skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        playBackgroundMusic(k.Sounds.blipBlop)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseGame), name: Notification.Name(rawValue: kPausedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unPauseGame), name: Notification.Name(rawValue: kUnPausedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeMusic), name: Notification.Name(rawValue: "playMusic"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseMusic), name: Notification.Name(rawValue: "stopMusic"), object: nil)
        
        let gmodesHelper = GameModeHelper()
        gmodesHelper.initPointsCheck()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 4
        view.addGestureRecognizer(tap)
        
        //TODO: Developer Mode
        let vcRecog = VoiceRecognitionHelper()
        vcRecog!.start()
    }
    
    func pauseGame() {
        if UserDefaults.standard.bool(forKey: "nk") == true {
            print("Pause wont work!")
        } else {
            skView.isPaused = true
            
            let visualEffect = UIBlurEffect(style: .dark)
            blurView = UIVisualEffectView(effect: visualEffect)
            blurView.frame = view!.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurView)
            
            counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            counterLabel.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 25)
            counterLabel.textAlignment = NSTextAlignment.center
            counterLabel.text = "3"
            counterLabel.font = UIFont(name: k.Montserrat.Regular, size: 32)
            counterLabel.textColor = UIColor.white
            counterLabel.alpha = 0
            self.view.addSubview(counterLabel)
            
            pauseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            pauseLabel.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 30)
            pauseLabel.textAlignment = NSTextAlignment.center
            pauseLabel.text = "Game Paused"
            pauseLabel.font = UIFont(name: k.Montserrat.Light, size: 22)
            pauseLabel.textColor = UIColor.white
            pauseLabel.alpha = 0
            self.view.addSubview(pauseLabel)
        }
    }
    
    func unPauseGame() {
        var counter = 3
        pausedTimer = Timer.every(1, {
            if counter > 1 {
                counter -= 1
                self.counterLabel.text = String(counter)
            } else if counter < 1 {
                self.counterLabel.text = "0"
                self.pausedTimer.invalidate()
                self.animate()
                
            }
            
        })
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, animations: {
            self.counterLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
            self.counterLabel.alpha = 1
            }, completion: { (value: Bool) in
                
                let delayTime = DispatchTime.now() + Double(Int64(1.85 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                    UIView.animate(withDuration: 1, animations: {
                        self.counterLabel.alpha = 0
                        self.counterLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 25)
                        self.blurView.alpha = 0
                        
                        }, completion: { (value: Bool) in
                            self.counterLabel.removeFromSuperview()
                            self.blurView.removeFromSuperview()
                            
                            self.skView.isPaused = false
                    })
                }
        })

    }
    
    func resumeMusic() {
        if !backgroundMusicPlayer.isPlaying {
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
    }
    
    func pauseMusic() {
        if backgroundMusicPlayer.isPlaying {
            backgroundMusicPlayer.pause()
        }
    }
    
    func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            backgroundMusicPlayer.volume = 0.7
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func handleTap() {
        // handling code
        let alert = UIAlertController(title: "Enter amount of points", message: "For testing", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Max 999,999,999"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            
            let tapped = Int(textField.text!)
            UserDefaults.standard.set(tapped, forKey: kNumbersKey) 
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }  
    
}
