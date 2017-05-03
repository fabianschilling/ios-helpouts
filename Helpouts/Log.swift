//
//  Log.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/3/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

class Log {
    
    class func log(_ message: String, sender: AnyObject, function: String = #function) {
        let fullClassName = NSStringFromClass(sender.classForCoder)
        let components = fullClassName.components(separatedBy: ".")
        let className = components[1]
    }
    
    class func log(_ message: AnyObject, file: String = #file, function: String = #function) {
        let fileName = file.components(separatedBy: "/").last
        let className = fileName?.components(separatedBy: ".").first
        // include function later on maybe
        println("\(className!): \(message)")
    }
}
