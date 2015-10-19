//
//  DataManager.swift
//  Kiss
//
//  Created by thieblin on 11/2/14.
//  Copyright (c) 2014 actimust. All rights reserved.
//

import UIKit

private let _SingletonSharedInstance = DataManager()

class DataManager: NSObject {
    
    var aryUsers : NSMutableArray = NSMutableArray()
    
    class var sharedInstance : DataManager {
        return _SingletonSharedInstance
    }
    
    override init() {
        
    }
}
