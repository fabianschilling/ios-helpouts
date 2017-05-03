//
//  CircleButton.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/29/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    // MARK: - Class variables
    
    var image: UIImage! {
        didSet {
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: { () -> Void in
                self.setBackgroundImage(self.image, for: UIControlState())
            }, completion: nil)
        }
    }
    
    // MARK: - Designated Initializer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCircleButton()
    }
    
    // MARK: - Convenience Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircleButton()
    }
    
    // MARK: View Setup
    
    func setupCircleButton() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        
        //let defaultProfileImage = UIImage(named: Constants.Images.DefaultProfileImage)
        //self.setBackgroundImage(defaultProfileImage, forState: .Normal)
        //self.backgroundColor = UIColor.blackColor()
    }
    
    

}
