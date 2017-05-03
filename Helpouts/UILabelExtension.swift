//
//  UILabelExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/8/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    
    class func backgroundForTableView(_ tableView: UITableView, withText text: String) -> UILabel {
        
        let label = UILabel(frame: tableView.bounds)
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }
    
}
