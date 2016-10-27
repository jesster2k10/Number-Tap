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
import PeekView

let kShareNotification = "share"
let kShareHiddenNotificaion = "hidden"

let kShareNotification2 = "share2"
let kShareHiddenNotificaion2 = "hidden2"

class GameViewController: UIViewController, ADBannerViewDelegate {
    var backgroundMusicPlayer = AVAudioPlayer()
    
    @IBOutlet weak var bannerView: ADBannerView!
    var isBannerVisible = false
    
    @IBOutlet weak var shareBlurView: UIVisualEffectView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var shareImage: RotatableImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var continueShare: UIButton!
    @IBOutlet weak var shareFrame: UIImageView!
    
    var shareMessage = ""
    var shareURL = NSURL()
    
    var isShareEnabled = false
    var ForceTouchedEnabled = false
    var gestureRecog = UILongPressGestureRecognizer()
    
    @IBOutlet weak var shareLabel1: UILabel!
    @IBOutlet weak var shareLabel2: UILabel!
    @IBOutlet weak var shareLabel3: UILabel!
    
    let shareLabel1Array = ["Well, you did try", "Well, I'm surprised", "OMFG, No way!"]
    let shareLabel2Array = ["Pretty pathetic to be honest", "You're actually doing pretty well", "No way you got that! You must've hacked!"]
    let shareLabel3Array = ["How about we go again?", "The more you practice the better you get!", "Prove to me that you're legit then."]
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(showShare), name: Notification.Name(rawValue: kShareNotification2), object: nil)
        
        if !ForceTouchedEnabled {
            gestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(setUpPeekView(_ :)))
            gestureRecog.minimumPressDuration = 0.5
            shareFrame.addGestureRecognizer(gestureRecog)
        }
        
        shareView.alpha = 0
        shareView.isUserInteractionEnabled = false
        
        shareBlurView.alpha = 0
        shareButton.setImage(UIImage(named: "polaroid-share".localized), for: .normal)
        
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
        let score = userInfo!["score"] as! Int
        
        shareMessage = userInfo!["message"] as! String
        shareURL = userInfo!["shareURL"] as! NSURL
        
        shareImage.image = image
        
        if score < 24 {
            shareLabel1.text = shareLabel1Array[0]
            shareLabel2.text = shareLabel2Array[0]
            shareLabel3.text = shareLabel3Array[0]
        } else if score > 24 && score < 50 {
            shareLabel1.text = shareLabel1Array[1]
            shareLabel2.text = shareLabel2Array[1]
            shareLabel3.text = shareLabel3Array[1]
        } else if score > 50 {
            shareLabel1.text = shareLabel1Array[2]
            shareLabel2.text = shareLabel2Array[2]
            shareLabel3.text = shareLabel3Array[2]
        }
        
        UIView.animate(withDuration: 0.05, animations: {
            self.shareView.alpha = 1
            self.shareBlurView.alpha = 1
            self.shareView.isUserInteractionEnabled = true
        }) { (completed) in
            self.isShareEnabled = true
        }
    }
    
    func hideShare() {
        UIView.animate(withDuration: 1, animations: {
            self.shareView.alpha = 0
            self.shareView.isUserInteractionEnabled = false
            self.shareBlurView.alpha = 0
        }) { (completed) in
            self.isShareEnabled = false
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kShareHiddenNotificaion), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kShareHiddenNotificaion2), object: nil)
    }
    
    @IBAction func share(_ sender: AnyObject) {
        let objectsToShare = [shareMessage, shareURL, shareImage.image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func setUpPeekView(_ gestureRecogniser: UILongPressGestureRecognizer) {
        if !ForceTouchedEnabled {
            let options = [ PeekViewAction(title: "Cancel", style: .destructive),
                            PeekViewAction(title: "Share", style: .default)     ]
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "share") as! ShareImageViewController
            controller.shareImage = shareImage.image!
            
            let frame = CGRect(x: 15, y: (self.view.frame.height - 300)/2, width: self.view.frame.width - 30, height: 300)
            
            PeekView().viewForController(parentViewController: self, contentViewController: controller, expectedContentViewFrame: frame, fromGesture: gestureRecogniser, shouldHideStatusBar:  true, withOptions:  options, completionHandler:  { optionIndex in
                switch optionIndex {
                case 0:
                    print("Cancel Selected")
                case 1:
                    print("Share selected")
                    self.share(self)
                default:
                    break
                }
                
            })
        }
        
    }
    
    @IBAction func skip(_ sender: AnyObject) {
        hideShare()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shareVC = segue.destination as? ShareImageViewController {
            shareVC.shareImage = self.shareImage.image!
        }
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
