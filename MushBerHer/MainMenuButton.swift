//
//  MainMenuButton.swift
//  MushBerHer
//
//  Created by Oleg on 21/06/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit

class MainMenuButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
    }

}
