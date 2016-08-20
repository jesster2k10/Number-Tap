//
//  FTLogging.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import Foundation

public class FTLogging {
    
    private var isDebug: Bool
    
    init() {
        self.isDebug = false
    }
    
    public func setup (isDebug: Bool) {
        self.isDebug = isDebug
        print("Project is Debug = \(isDebug)")
    }
    
    public func FTLog<T> (value : T) {
        if isDebug == true {
            print(value)
        }
    }
}