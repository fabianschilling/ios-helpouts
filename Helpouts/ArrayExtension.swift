//
//  ArrayExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/19/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if index != nil {
            self.remove(at: index!)
        }
    }
}
