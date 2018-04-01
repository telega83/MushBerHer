//
//  TmpVC.swift
//  MushBerHer
//
//  Created by Oleg on 29/11/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import UIKit
import AEXML
import SQLiteManager

class StartVC: UIViewController {
    
    @IBOutlet weak var btnDataPreparation: UIButton!
    @IBOutlet weak var actDB: UIActivityIndicatorView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        actDB.startAnimating()
        
        let loadQueue = DispatchQueue.global(qos: .utility)
        let workItem = DispatchWorkItem {
            MBHDB.sharedInstance.wakeUp()
        }
        loadQueue.async(execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main) {
            self.actDB.isHidden = true
            self.btnDataPreparation.isHidden = true
            //self.lblLogo.isHidden = false
            self.imgLogo.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.performSegue(withIdentifier: "startToMain", sender: self)
            })
        }
    }
}

