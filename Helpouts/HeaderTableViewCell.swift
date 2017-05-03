//
//  HeaderTableViewCell.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/14/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1.0 / UIScreen.main.scale)
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowRadius = 0
    }

    @IBOutlet weak var creatorProfileButton: CircleButton!
    @IBOutlet weak var creatorLabel: UILabel!
    
    @IBOutlet weak var helperProfileButton: CircleButton!
    @IBOutlet weak var helperLabel: UILabel!
    
    @IBOutlet weak var helpoutLabel: UILabel!

}
