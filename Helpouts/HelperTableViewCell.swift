//
//  HelperTableViewCell.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/12/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class HelperTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: CircleButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            self.accessoryType = UITableViewCellAccessoryType.none
        }
        
    }
}
