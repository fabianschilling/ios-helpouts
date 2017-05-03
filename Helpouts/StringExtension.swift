//
//  StringExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/16/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
    
    var isValidName: Bool {
        return count(self) > 2
    }
    
    var isValidPassword: Bool {
        return count(self) > 7 // test if email contains numbers etc. in future
    }
}