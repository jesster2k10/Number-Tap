//
//  Extensions.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit
import UIKit
import SystemConfiguration
import ObjectiveC

extension SKScene {
    private func getBluredScreenshot() -> SKSpriteNode{
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view!.frame.size.width, height: self.view!.frame.size.height), true, 1)
        
        self.view!.drawHierarchy(in: self.view!.frame, afterScreenUpdates: true)
        
        let context = UIGraphicsGetCurrentContext()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(3, forKey: kCIInputRadiusKey)
        
        let filteredImageData = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredImage = UIImage(cgImage: filteredImageRef!)
        
        let texture = SKTexture(image: filteredImage)
        let sprite = SKSpriteNode(texture:texture)
        
        sprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let scale:CGFloat = UIScreen.main.scale
        
        sprite.size.width  *= scale
        sprite.size.height *= scale
        
        return sprite
        
    }
    
    func blur(animationDuration: Int) {
        let pauseBG:SKSpriteNode = self.getBluredScreenshot()
        
        pauseBG.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        pauseBG.alpha = 0
        pauseBG.zPosition = self.zPosition + 1
        pauseBG.run(SKAction.fadeAlpha(to: 1, duration: TimeInterval(animationDuration)))
        
        self.addChild(pauseBG)
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


func associatedObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

enum ShortcutIdentifier: String {
    case OpenFavorites
    case OpenFeatured
    case OpenTopRated
    
}

class Used {
    var used = false
}

private var usedKey: UInt8 = 0
extension SKShapeNode {
    /// Used for the bullet
    var used: Used {
        get {
            return associatedObject(self, key: &usedKey)
            { return Used() } // Set the initial value of the var
        }
        set { associateObject(self, key: &usedKey, value: newValue) }
    }
    
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension TimeInterval {
    var stringValue: String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}

extension Double {
    public var millisecond: TimeInterval  { return self / 1000 }
    public var milliseconds: TimeInterval { return self / 1000 }
    public var ms: TimeInterval           { return self / 1000 }
    
    public var second: TimeInterval       { return self }
    public var seconds: TimeInterval      { return self }
    
    public var minute: TimeInterval       { return self * 60 }
    public var minutes: TimeInterval      { return self * 60 }
    
    public var hour: TimeInterval         { return self * 3600 }
    public var hours: TimeInterval        { return self * 3600 }
    
    public var day: TimeInterval          { return self * 3600 * 24 }
    public var days: TimeInterval         { return self * 3600 * 24 }
}

open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

}

struct SocialNetworkUrl {
    let scheme: String
    let page: String
    
    func openPage() {
        let schemeUrl = URL(string: scheme)!
        if UIApplication.shared.canOpenURL(schemeUrl) {
            UIApplication.shared.openURL(schemeUrl)
        } else {
            UIApplication.shared.openURL(URL(string: page)!)
        }
    }
}

enum SocialNetwork {
    case facebook, googlePlus, twitter, instagram
    func url() -> SocialNetworkUrl {
        switch self {
        case .facebook: return SocialNetworkUrl(scheme: "fb://profile/831944953601016", page: "https://www.facebook.com/831944953601016")
        case .twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=USERNAME", page: "https://twitter.com/USERNAME")
        case .googlePlus: return SocialNetworkUrl(scheme: "gplus://plus.google.com/u/0/PageId", page: "https://plus.google.com/PageId")
        case .instagram: return SocialNetworkUrl(scheme: "instagram://user?username=USERNAME", page:"https://www.instagram.com/USERNAME")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}

extension UIApplication {
    class func tryURL(_ urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}

public enum Model : String {
    case simulator = "simulator/sandbox",
    iPod1          = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadMini4      = "iPad Mini 4",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    unrecognized   = "?unrecognized?"
}

extension Date {
    static func daysBetweenThisDate(_ fromDateTime: Date, andThisDate toDateTime: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: fromDateTime, to: toDateTime)
        return components.day!
    }
    
}

extension UIScreen {
    public func isRetina() -> Bool {
        return screenScale() >= 2.0
    }
    
    public func isRetinaHD() -> Bool {
        return screenScale() >= 3.0
    }
    
    fileprivate func screenScale() -> CGFloat? {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            return UIScreen.main.scale
        }
        return nil
    }
}

extension UIView {
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    
    class func keyAlreadyExists(_ kUsernameKey: String) -> Bool {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "TheFirstLaunchFlag1"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            UserDefaults.standard.set("false" as NSCoding, forKey: firstLaunchFlag)
        } else {
            return false
        }
        return true
    }
    
    var highScore: Int {
        get {
            
            //print("High Score = " + (UserDefaults().integer(forKey: "highScore").description))
            return UserDefaults().integer(forKey: "highScore")
        }
        set {
            guard newValue > highScore else { print("\(newValue) ≤ \(highScore) Try again")
                return
            }
            UserDefaults().set(newValue, forKey: "highScore")
            print("New High Score = \(highScore)")
        }
    }
    func resetHighScore() {
        UserDefaults().removeObject(forKey: "highScore")
        print("removed object for key highScore")
    }
    
    func resetHighScoreDouble() {
        UserDefaults.standard.removeObject(forKey: "highScoreDouble")
        print("removed object for key highScoreDouble")
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


