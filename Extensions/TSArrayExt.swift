//
//  ArrayExt.swift
//  Memory
//
//  Created by Tanya Sahin on 11/30/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for (var i = 0; i < self.count; i++) {
            let randomNumber = Int(arc4random_uniform(UInt32(self.count-i)))+i
            swap(&self[i], &self[randomNumber])
        }
    }
}