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
import iAd

let kShareNotification = "share"

class GameViewController: UIViewController, ADBannerViewDelegate {
    var backgroundMusicPlayer = AVAudioPlayer()
    
    @IBOutlet weak var bannerView: ADBannerView!
    var isBannerVisible = false
    
    @IBOutlet weak var shareBlurView: UIVisualEffectView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var shareImage: RotatableImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    var shareMessage = ""
    var shareURL = NSURL()
    
    var isShareEnabled = false
    
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
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.isPaused = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        playBackgroundMusic(k.Sounds.blipBlop)
        
        GCHelper.sharedGameKitHelper.authenticateLocalPlayer()
        
        bannerView.alpha = 0
        bannerView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeMusic), name: Notification.Name(rawValue: "playMusic"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseMusic), name: Notification.Name(rawValue: "stopMusic"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideBanner), name: Notification.Name(rawValue: "hideBanner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showBanner), name: Notification.Name(rawValue: "showBanner"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showShare), name: Notification.Name(rawValue: kShareNotification), object: nil)
        
        let gmodesHelper = GameModeHelper()
        gmodesHelper.initPointsCheck()
        
        if !kIsAppLive {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tap.numberOfTapsRequired = 4
            view.addGestureRecognizer(tap)
        }
    }
    
    func hideBanner() {
        UIView.animate(withDuration: 1, animations: { 
            self.bannerView.alpha = 0
            }) { (completed) in
                self.isBannerVisible = false
        }
    }
    
    func showBanner() {
        UIView.animate(withDuration: 1, animations: {
            self.bannerView.alpha = 1
        }) { (completed) in
            self.isBannerVisible = true
        }
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
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        if !isBannerVisible {
            UIView.animate(withDuration: 1, animations: {
                self.bannerView.alpha = 1
            }) { (completed) in
                self.isBannerVisible = true
            }
        }
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        print("Failed to retrive ad: \(error.localizedDescription)")
        if isBannerVisible {
            UIView.animate(withDuration: 1, animations: {
                self.bannerView.alpha = 0
            }) { (completed) in
                self.isBannerVisible = false
            }
        }
    }
    
    func showShare(_ aNotificaton: NSNotification) {
        let userInfo = aNotificaton.userInfo
        let image = userInfo!["image"] as! UIImage
        
        shareMessage = userInfo!["message"] as! String
        shareURL = userInfo!["shareURL"] as! NSURL
        
        shareImage.image = image
        
        UIView.animate(withDuration: 1, animations: {
            self.shareView.alpha = 1
            self.shareBlurView.alpha = 1
        }) { (completed) in
            self.isShareEnabled = true
        }
    }
    
    func hideShare(_ aNotificaton: NSNotification) {
        UIView.animate(withDuration: 1, animations: {
            self.shareView.alpha = 0
            self.shareBlurView.alpha = 0
        }) { (completed) in
            self.isShareEnabled = false
        }
    }
    
    @IBAction func share(_ sender: AnyObject) {
        let objectsToShare = [shareMessage, shareURL, shareImage.image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        
        self.present(activityVC, animated: true, completion: nil)

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
