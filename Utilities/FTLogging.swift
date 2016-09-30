//
//  FTLogging.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import Foundation

open class FTLogging {
    
    fileprivate var isDebug: Bool
    
    init() {
        self.isDebug = false
    }
    
    open func setup (_ isDebug: Bool) {
        self.isDebug = isDebug
        print("Project is Debug = \(isDebug)")
    }
    
    open func FTLog<T> (_ value : T) {
        if isDebug == true {
            print(value)
        }
    }
}
