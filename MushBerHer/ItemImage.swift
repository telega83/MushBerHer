//
//  ItemImage.swift
//  MushBerHer
//
//  Created by Oleg on 27/09/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit

class ItemImage: UIImageView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        
        layer.borderWidth  = 3.0
    }
}
