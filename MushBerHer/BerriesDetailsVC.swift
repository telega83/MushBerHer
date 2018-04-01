//
//  BerriesDetailsVC.swift
//  MushBerHer
//
//  Created by Oleg on 20/11/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit

class BerriesDetailsVC: UIViewController {

    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var itemTitle = String()
    var img = String()
    var text = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        imgItem.image = UIImage(named: img)
        lblTitle.text = itemTitle
        
        let attrText = TextFormatter(text: text).getAttributedText()
        txtDetails.attributedText = attrText
    }
}
