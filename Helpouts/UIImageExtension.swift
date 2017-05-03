//
//  UIImageExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/20/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation
import CloudKit

extension UIImage {
    
    func toCKAsset() -> CKAsset? {
        
        let newSize = CGSizeMake(400, 400)
        
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let data = UIImageJPEGRepresentation(image, 0.75)
        UIGraphicsEndImageContext()
        
        if let cachesDirectory = FileManager.defaultManager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
            if let temporaryName = NSUUID().UUIDString.stringByAppendingPathExtension("jpeg") {
                let localURL = cachesDirectory.URLByAppendingPathComponent(temporaryName)
                data.writeToURL(localURL, atomically: true)
                let imageAsset = CKAsset(fileURL: localURL)
                return imageAsset
            }
        }
        return nil
    }
    
    func saveToFile(_ filename: String){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        let destinationPath = documentsPath.stringByAppendingPathComponent("\(filename).jpg")
        let imageData = UIImageJPEGRepresentation(self, 0.75)
        imageData.writeToFile(destinationPath, atomically: true)
        Log.log("Saving image: \(destinationPath)")
    }
}
