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

func associatedObject<ValueType: AnyObject>(
    base: AnyObject,
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
    base: AnyObject,
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

extension NSTimeInterval {
    var stringValue: String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}

extension Double {
    public var millisecond: NSTimeInterval  { return self / 1000 }
    public var milliseconds: NSTimeInterval { return self / 1000 }
    public var ms: NSTimeInterval           { return self / 1000 }
    
    public var second: NSTimeInterval       { return self }
    public var seconds: NSTimeInterval      { return self }
    
    public var minute: NSTimeInterval       { return self * 60 }
    public var minutes: NSTimeInterval      { return self * 60 }
    
    public var hour: NSTimeInterval         { return self * 3600 }
    public var hours: NSTimeInterval        { return self * 3600 }
    
    public var day: NSTimeInterval          { return self * 3600 * 24 }
    public var days: NSTimeInterval         { return self * 3600 * 24 }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

struct SocialNetworkUrl {
    let scheme: String
    let page: String
    
    func openPage() {
        let schemeUrl = NSURL(string: scheme)!
        if UIApplication.sharedApplication().canOpenURL(schemeUrl) {
            UIApplication.sharedApplication().openURL(schemeUrl)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: page)!)
        }
    }
}

enum SocialNetwork {
    case Facebook, GooglePlus, Twitter, Instagram
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook: return SocialNetworkUrl(scheme: "fb://profile/831944953601016", page: "https://www.facebook.com/831944953601016")
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=USERNAME", page: "https://twitter.com/USERNAME")
        case .GooglePlus: return SocialNetworkUrl(scheme: "gplus://plus.google.com/u/0/PageId", page: "https://plus.google.com/PageId")
        case .Instagram: return SocialNetworkUrl(scheme: "instagram://user?username=USERNAME", page:"https://www.instagram.com/USERNAME")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
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

extension NSDate {
    class func daysBetweenThisDate(fromDateTime:NSDate, andThisDate toDateTime:NSDate)->Int?{
        
        var fromDate:NSDate? = nil
        var toDate:NSDate? = nil
        
        let calendar = NSCalendar.currentCalendar()
        
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        if let from = fromDate {
            
            if let to = toDate {
                
                let difference = calendar.components(NSCalendarUnit.Day, fromDate: from, toDate: to, options: NSCalendarOptions())
                
                return difference.day
            }
        }
        
        return nil
    }
    
    
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
}

extension UIScreen {
    public func isRetina() -> Bool {
        return screenScale() >= 2.0
    }
    
    public func isRetinaHD() -> Bool {
        return screenScale() >= 3.0
    }
    
    private func screenScale() -> CGFloat? {
        if UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)) {
            return UIScreen.mainScreen().scale
        }
        return nil
    }
}

extension UIView {
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafeMutablePointer(&systemInfo.machine) {
            ptr in String.fromCString(UnsafePointer<CChar>(ptr))
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,1"   : .iPadAir1,
            "iPad4,2"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus
        ]
        
        if let model = modelMap[String.fromCString(modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}


extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    
    class func keyAlreadyExists(kUsernameKey: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(kUsernameKey) != nil
    }
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
    
    var highScore: Int {
        get {
            FTLogging().FTLog("High Score = " + integerForKey("highScore").description)
            return integerForKey("highScore")
        }
        set {
            guard newValue > highScore else { FTLogging().FTLog("\(newValue) ≤ \(highScore) Try again")
                return
            }
            setInteger(newValue, forKey: "highScore")
            FTLogging().FTLog("New High Score = \(highScore)")
        }
    }
    func resetHighScore() {
        removeObjectForKey("highScore")
        FTLogging().FTLog("removed object for key highScore")
    }
    var highScoreDouble: Double {
        get {
            return doubleForKey("highScoreDouble")
        }
        set {
            guard newValue > highScoreDouble else { print("Try again")
                return
            }
            setDouble(newValue, forKey: "highScoreDouble")
            FTLogging().FTLog("New High Score = \(highScoreDouble)")
        }
    }
    func resetHighScoreDouble() {
        removeObjectForKey("highScoreDouble")
        FTLogging().FTLog("removed object for key highScoreDouble")
    }
}




