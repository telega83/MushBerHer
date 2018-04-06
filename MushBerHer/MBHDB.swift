//
//  MBHDB.swift
//  MushBerHer
//
//  Created by Oleg on 28/05/2017.
//  Copyright © 2017 telega. All rights reserved.
//  

import Foundation
import AEXML
import SQLiteManager

class MBHDB {
    
    static let sharedInstance = MBHDB()
    
    var MBHItems = [MBHItem]()
    
    //Items
    var MBHItemsMushrooms = [MBHItem]()
    var MBHItemsBerries = [MBHItem]()
    var MBHItemsHerbs = [MBHItem]()
    
    //UITableView offsets
    var mushroomsContentOffset: CGPoint
    var berriesContentOffset: CGPoint
    var herbsContentOffset: CGPoint
    
    //UISearchBars values
    var mushroomsSearchBarText = String()
    var berriesSearchBarText = String()
    var herbsSearchBarText = String()
    
    var mushroomsShowFavourites: Bool
    var berriesShowFavourites: Bool
    var herbsShowFavourites: Bool
    
    //Filters
    var mushroomsEdibilityFilter: [UInt] = [1, 2, 3, 4, 5, 6]
    var mushroomsHarvestFilter: [Int] = [0, 1, 2, 3, 4]
    var berriesEdibilityFilter: [UInt] = [1, 2, 3, 4, 5, 6]
    var berriesHarvestFilter: [Int] = [0, 1, 2, 3, 4]
    
    func wakeUp () {
        //Initialises singleton
    }
    
    private init() {
        //Reset content offsets
        mushroomsContentOffset = CGPoint(x: 0, y: 0)
        berriesContentOffset = CGPoint(x: 0, y: 0)
        herbsContentOffset = CGPoint(x: 0, y: 0)
        
        //Reset favourites switches
        mushroomsShowFavourites = false
        berriesShowFavourites = false
        herbsShowFavourites = false
        
        //Create DB
        createDB()
    }
    
    func showDBErrorWarning(sender: UIViewController) {
        let alert = UIAlertController(title: "Error :(", message: "Something went wrong while updating database", preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    private func createDB(){
        //Transfer data from XML if DB is empty
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            let resItems = try database.query("select * from item order by id asc")
            
            //Must use 'get count' here to improve performance
            
            if resItems.affectedRowCount == 0 {
                getItemsFromXML(file: "type_1", category: 1)
                getItemsFromXML(file: "type_2", category: 2)
                getItemsFromXML(file: "type_3", category: 3)
                
                for item in MBHItemsMushrooms {
                    let insertQuery = "insert into item (id, category_id, item_id, edibility_id, title, title_advanced, additional, prologue, text, notes, isFav) values (null,  \(item.category_id), \(item.id), \(item.edibility_id), '\(item.title)', '\(item.title_advanced)', '\(item.additional)', '\(item.prologue)', '\(item.text)', '\(item.notes)', 0)"
                    let insertHarvestQueries = item.harvestData.generateInsertHarvestQueries(itemId: item.id, categoryId: item.category_id)
                    
                    //Inserting item
                    let _ = try database.query(insertQuery)
                    //Inserting item's harvest data
                    for query in insertHarvestQueries[0].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[1].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[2].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[3].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                }
                
                for item in MBHItemsBerries {
                    let insertQuery = "insert into item (id, category_id, item_id, edibility_id, title, title_advanced, additional, prologue, text, notes, isFav) values (null,  \(item.category_id), \(item.id), \(item.edibility_id), '\(item.title)', '\(item.title_advanced)', '\(item.additional)', '\(item.prologue)', '\(item.text)', '\(item.notes)', 0)"
                    let insertHarvestQueries = item.harvestData.generateInsertHarvestQueries(itemId: item.id, categoryId: item.category_id)
                    
                    //Inserting item
                    let _ = try database.query(insertQuery)
                    //Inserting item's harvest data
                    for query in insertHarvestQueries[0].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[1].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[2].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[3].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                }
                
                for item in MBHItemsHerbs {
                    let insertQuery = "insert into item (id, category_id, item_id, edibility_id, title, title_advanced, additional, prologue, text, notes, isFav) values (null,  \(item.category_id), \(item.id), \(item.edibility_id), '\(item.title)', '\(item.title_advanced)', '\(item.additional)', '\(item.prologue)', '\(item.text)', '\(item.notes)', 0)"
                    let insertHarvestQueries = item.harvestData.generateInsertHarvestQueries(itemId: item.id, categoryId: item.category_id)
                    
                    //Inserting item
                    let _ = try database.query(insertQuery)
                    //Inserting item's harvest data
                    for query in insertHarvestQueries[0].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[1].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[2].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                    for query in insertHarvestQueries[3].split(separator: "|") {
                        let _ = try database.query(String(query))
                    }
                }
            } else { //Get data from DB
                getItemsFromDB(category: 1)
                getItemsFromDB(category: 2)
                getItemsFromDB(category: 3)
            }
        } catch {
            return
        }
    }
    
    private func getItemsFromDB(category: UInt) {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            let resItems = try database.query("select * from item where category_id = \(category) order by id asc")
            
            for item in resItems.results! {
                let id = item["item_id"] as! UInt
                let edibility_id = item["edibility_id"] as! UInt
                let title = item["title"] as! String
                let title_advanced = item["title_advanced"] as! String
                let additional = item["additional"] as! String
                let prologue = item["prologue"] as! String
                let text = item["text"] as! String
                let notes = item["notes"] as! String
                let isFavourite = item["isFav"] as! Int
                
                let harvestRawData = try database.query("select type, day_min, day_max from harvest where item_id = \(id) and category_id = \(category)")
                let harvestData = MBHItemHarvest(rawData: harvestRawData)
                
                if(category == 1) {
                    MBHItemsMushrooms.append(MBHItem(id: id, category_id: category, edibility_id: edibility_id, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: isFavourite))
                } else if(category == 2) {
                    MBHItemsBerries.append(MBHItem(id: id, category_id: category, edibility_id: edibility_id, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: isFavourite))
                } else if(category == 3) {
                    MBHItemsHerbs.append(MBHItem(id: id, category_id: category, edibility_id: edibility_id, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: isFavourite))
                }
            }
        } catch {
            return
        }
    }
    
    private func getItemsFromXML(file: String, category: UInt) {
        guard let
            xmlPath = Bundle.main.path(forResource: file, ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
            else { return }
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
         
            for item in xmlDoc.root["item"].all! {
                let id = UInt(item["id"].value!)
                let category_id: UInt = category
                let edibility_id = UInt(item["edibility"].value!)
                let title = item["title"].value!
                let title_advanced = item["title_advanced"].value!
                let additional = item["additional"].value!
                let prologue = item["prologue"].value!
                let text = item["text"].value!
                let notes = ""
                
                var start: String = "0-0"
                var poor: String = "0-0"
                var mass: String = "0-0"
                var end: String = "0-0"
                
                //Provided not for all items!
                //Checking whether is nil
                if let _ = item["start"].value,
                    let _ = item["poor"].value,
                    let _ = item["mass"].value,
                    let _ = item["end"].value {
                    start = item["start"].value!
                    poor = item["poor"].value!
                    mass = item["mass"].value!
                    end = item["end"].value!
                }
                
                let harvestData = MBHItemHarvest(startRanges: start, poorRanges: poor, massRanges: mass, endRanges: end)
                
                if(category == 1) {
                    MBHItemsMushrooms.append(MBHItem(id: id!, category_id: category_id, edibility_id: edibility_id!, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: 0))
                } else if(category == 2) {
                    MBHItemsBerries.append(MBHItem(id: id!, category_id: category_id, edibility_id: edibility_id!, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: 0))
                } else if(category == 3) {
                    MBHItemsHerbs.append(MBHItem(id: id!, category_id: category_id, edibility_id: edibility_id!, title: title, title_advanced: title_advanced, additional: additional, prologue: prologue, text: text, notes: notes, harvestData: harvestData, isFavourite: 0))
                }
            }
        } catch {
            return
        }
    }
    
    func getItems(category: UInt) -> [MBHItem]{
        var result = [MBHItem]()
        if category == 1 {
            if mushroomsShowFavourites {
                result = MBHItemsMushrooms.filter({$0.isFavourite == 1 && mushroomsEdibilityFilter.contains($0.edibility_id)  && mushroomsHarvestFilter.contains($0.harvestData.getHarvestStatus())})
            } else {
                result = MBHItemsMushrooms.filter({mushroomsEdibilityFilter.contains($0.edibility_id)  && mushroomsHarvestFilter.contains($0.harvestData.getHarvestStatus())})
            }
        } else if category == 2 {
            if berriesShowFavourites {
                result = MBHItemsBerries.filter({$0.isFavourite == 1 && berriesEdibilityFilter.contains($0.edibility_id)  && berriesHarvestFilter.contains($0.harvestData.getHarvestStatus())})
            } else {
                result = MBHItemsBerries.filter({berriesEdibilityFilter.contains($0.edibility_id)  && berriesHarvestFilter.contains($0.harvestData.getHarvestStatus())})
            }
        } else if category == 3{
            if herbsShowFavourites {
                result = MBHItemsHerbs.filter({$0.isFavourite == 1})
            } else {
                result = MBHItemsHerbs
            }
        }
        return result
    }
    
    private func setFavouriteInDB(id: UInt, category_id: UInt, isFavourite: Int) {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            _ = try database.query("update item set isFav = \(isFavourite) where item_id = \(id) and category_id = \(category_id)")
        } catch {
            return
        }
    }
    
    func setFavourite(id: UInt, category_id: UInt) {
        if category_id == 1 {
            if MBHItemsMushrooms.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 0 {
                MBHItemsMushrooms.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 1
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 1)
            } else if MBHItemsMushrooms.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 1 {
                MBHItemsMushrooms.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 0
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 0)
            }
        } else if category_id == 2 {
            if MBHItemsBerries.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 0 {
                MBHItemsBerries.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 1
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 1)
            } else if MBHItemsBerries.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 1 {
                MBHItemsBerries.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 0
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 0)
            }
        } else if category_id == 3 {
            if MBHItemsHerbs.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 0 {
                MBHItemsHerbs.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 1
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 1)
            } else if MBHItemsHerbs.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite == 1 {
                MBHItemsHerbs.filter({$0.id == id && $0.category_id == category_id})[0].isFavourite = 0
                setFavouriteInDB(id: id, category_id: category_id, isFavourite: 0)
            }
        }
    }
}
