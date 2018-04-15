//
//  InfoDetailsVC.swift
//  MushBerHer
//
//  Created by Oleg on 15/04/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class InfoDetailsVC: UIViewController {

    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var itemTitle = String()
    var text = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = itemTitle
        
        let attrText = TextFormatter(text: text).getAttributedText()
        txtDetails.attributedText = attrText
    }
}
