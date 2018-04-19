//
//  InfoVC.swift
//  MushBerHer
//
//  Created by Oleg on 14/04/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit

class InfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MBHDB.sharedInstance.MBHInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InfoTableViewCell {
            cell.img.image = UIImage(named: "info_icon_\(MBHDB.sharedInstance.MBHInfo[indexPath.row].icon)")
            cell.lblTitle.text = MBHDB.sharedInstance.MBHInfo[indexPath.row].title
            cell.lblTitleAdvanced.text = MBHDB.sharedInstance.MBHInfo[indexPath.row].titleAdvanced
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    //Navigate to Info details view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoDetails",
        let destination = segue.destination as? InfoDetailsVC,
        let row = tableView.indexPathForSelectedRow?.row {
            destination.itemTitle = MBHDB.sharedInstance.MBHInfo[row].title
            destination.text = "\(MBHDB.sharedInstance.MBHInfo[row].text_1)<p></p>\(MBHDB.sharedInstance.MBHInfo[row].text_2)<p></p>\(MBHDB.sharedInstance.MBHInfo[row].text_3)<p></p>\(MBHDB.sharedInstance.MBHInfo[row].text_4)"
            
        }
    }
}









