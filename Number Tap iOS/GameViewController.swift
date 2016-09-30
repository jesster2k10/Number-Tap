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

    override func viewDidLoad() {
        super.viewDidLoad()

        var scene = SKScene()
        
        if UserDefaults.isFirstLaunch() {
            scene = TutorialScene()
        } else {
            scene = HomeScene()
        }
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        playBackgroundMusic(k.Sounds.blipBlop)
        
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
    
    func pauseMusic() {
        if !backgroundMusicPlayer.isPlaying {
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
    }
    
    func resumeMusic() {
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
