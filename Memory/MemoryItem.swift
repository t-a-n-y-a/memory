//
//  MemoryItem.swift
//  Memory
//
//  Created by Tanya Sahin on 11/27/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit

class MemoryItem: NSObject {
   
    var matched = false
    let name : String
    let image : UIImage?
    
    init(let name aName : String) {
        name = aName
        image = UIImage(named: aName)
        
    }
    
}
