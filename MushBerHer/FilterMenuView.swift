//
//  FilterMenuView.swift
//  MushBerHer
//
//  Created by Oleg on 27/03/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class FilterMenuView: UIView {
    override func awakeFromNib() {
        
        self.layoutIfNeeded()
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        
        layer.borderWidth  = 3.0
    }
}
