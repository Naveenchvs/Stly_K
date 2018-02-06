//
//  ArrayExtension.swift
//  Fashion180
//
//  Created by Yogi on 11/01/17.
//  Copyright © 2017 Mobiware. All rights reserved.
//

extension Array where Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObjects(_ objects : [Iterator.Element]) {
        
        for object in objects
        {
            if let index = self.index(of: object) {
                self.remove(at: index)
            }
        }
        
    }
}
