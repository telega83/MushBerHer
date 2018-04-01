//
//  MushroomsTableViewCell.swift
//  MushBerHer
//
//  Created by Oleg on 07/08/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit

class MushroomsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleAdvanced: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var debug_cellNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
