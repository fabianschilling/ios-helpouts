//
//  AccessoryView.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/16/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class AccessoryView: UIView {


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0,height: -1.0 / UIScreen.main.scale)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 0
    }

}
