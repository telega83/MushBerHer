//
//  BerriesVC.swift
//  
//
//  Created by Oleg on 16/08/2017.
//
//

import UIKit

class BerriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFavourites: UIButton!
    
    var filteredData = [MBHItem]()
    var isSearching = false
    var resDataSet = [MBHItem]()
    
    @IBAction func btnFavouritesTapped(_ sender: Any) {
        if MBHDB.sharedInstance.berriesShowFavourites {
            btnFavourites.setImage(UIImage(named: "favourite"), for: UIControlState.normal)
            MBHDB.sharedInstance.berriesShowFavourites = false
            
            tableView.reloadData()
        } else {
            btnFavourites.setImage(UIImage(named: "not_favourite"), for: UIControlState.normal)
            MBHDB.sharedInstance.berriesShowFavourites = true
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        //Restore content offset
        tableView.setContentOffset(MBHDB.sharedInstance.berriesContentOffset, animated: true)
        
        //Restore UISearchBar value
        if MBHDB.sharedInstance.berriesSearchBarText != "" {
            //Restore text
            searchBar.text = MBHDB.sharedInstance.berriesSearchBarText
            //Trigger search
            searchBar(searchBar, textDidChange: MBHDB.sharedInstance.berriesSearchBarText)
        }
        
        //Restore favourites switch
        if !MBHDB.sharedInstance.berriesShowFavourites {
            btnFavourites.setImage(UIImage(named: "favourite"), for: UIControlState.normal)
            MBHDB.sharedInstance.berriesShowFavourites = false
        } else {
            btnFavourites.setImage(UIImage(named: "not_favourite"), for: UIControlState.normal)
            MBHDB.sharedInstance.berriesShowFavourites = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return MBHDB.sharedInstance.getItems(category: 2).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BerriesTableViewCell {
            if isSearching {
                //User filtered data set
                resDataSet = filteredData
            } else {
                resDataSet = MBHDB.sharedInstance.getItems(category: 2)
            }
            
            //cell.debug_cellNumber.text = "\(indexPath.row)"
            
            let harvestStatus = resDataSet[indexPath.row].harvestData.getHarvestStatus()
            
            switch harvestStatus {
            case 1:
                cell.layer.backgroundColor = UIColor(red:0.95, green:0.96, blue:0.62, alpha:1.0).cgColor
                
            case 2:
                cell.layer.backgroundColor = UIColor(red:0.95, green:0.96, blue:0.62, alpha:1.0).cgColor
                
            case 3:
                cell.layer.backgroundColor = UIColor(red:0.76, green:0.93, blue:0.73, alpha:1.0).cgColor
                
            case 4:
                cell.layer.backgroundColor = UIColor(red:0.95, green:0.96, blue:0.62, alpha:1.0).cgColor
                
            default:
                cell.layer.backgroundColor = UIColor.clear.cgColor
            }
            
            cell.img.image = UIImage(named: "item_2_\(resDataSet[indexPath.row].id)_thumb")
            
            switch resDataSet[indexPath.row].edibility_id {
            case 1:
                cell.img.layer.borderColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0).cgColor
            case 2:
                cell.img.layer.borderColor = UIColor(red:0.89, green:0.48, blue:0.48, alpha:1.0).cgColor
            case 3:
                cell.img.layer.borderColor = UIColor(red:0.73, green:0.75, blue:0.03, alpha:1.0).cgColor
            case 4:
                cell.img.layer.borderColor = UIColor(red:0.98, green:1.00, blue:0.00, alpha:1.0).cgColor
            case 5:
                cell.img.layer.borderColor = UIColor(red:0.00, green:0.83, blue:0.13, alpha:1.0).cgColor
            case 6:
                cell.img.layer.borderColor = UIColor(red:0.03, green:0.49, blue:0.11, alpha:1.0).cgColor
                
            default:
                cell.img.layer.borderColor = UIColor.white.cgColor
            }
            
            cell.lblTitle.text = resDataSet[indexPath.row].title
            cell.lblTitleAdvanced.text = resDataSet[indexPath.row].title_advanced
            if resDataSet[indexPath.row].isFavourite == 0 {
                cell.imgFavourite.isHidden = true
            } else if resDataSet[indexPath.row].isFavourite == 1 {
                cell.imgFavourite.isHidden = false
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = MBHDB.sharedInstance.getItems(category: 2).filter({$0.title.capitalized.range(of: searchBar.text!.capitalized) != nil || $0.title_advanced.capitalized.range(of: searchBar.text!.capitalized) != nil})
            tableView.reloadData()
        }
    }
    
    //Add to favourites / remove from favourites swipe menu
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favourites = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
            //add to/remove from favourites
            print("Hey! \(self.resDataSet[indexPath.row].title)")
            MBHDB.sharedInstance.setFavourite(id: self.resDataSet[indexPath.row].id, category_id: self.resDataSet[indexPath.row].category_id)
            tableView.reloadData()
        }
        
        if resDataSet[indexPath.row].isFavourite == 0 {
            favourites.backgroundColor = UIColor(patternImage: UIImage(named: "favourite_swipe")!)
        } else if resDataSet[indexPath.row].isFavourite == 1 {
            favourites.backgroundColor = UIColor(patternImage: UIImage(named: "not_favourite_swipe")!)
        }
        
        return [favourites]
    }
    
    //Navigate to mushroom details view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Save content offset value
        MBHDB.sharedInstance.berriesContentOffset = tableView.contentOffset
        
        if isSearching {
            MBHDB.sharedInstance.berriesSearchBarText = searchBar.text!
        } else {
            MBHDB.sharedInstance.berriesSearchBarText = ""
        }
        
        //Segue
        if  segue.identifier == "berriesDetails",
            let destination = segue.destination as? BerriesDetailsVC,
            let row = tableView.indexPathForSelectedRow?.row {
            destination.itemTitle = resDataSet[row].title
            destination.img = "item_2_\(resDataSet[row].id)"
            destination.text = resDataSet[row].text
        }
    }
}