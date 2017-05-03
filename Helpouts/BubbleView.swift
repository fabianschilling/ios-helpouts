//
//  BubbleView.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/29/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    
    // MARK - Designated Initializer

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBubbleView()
    }
    
    func setupBubbleView() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

}
