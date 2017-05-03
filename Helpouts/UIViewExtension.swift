//
//  UIViewExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/20/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibBNamed(_ nibName: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
