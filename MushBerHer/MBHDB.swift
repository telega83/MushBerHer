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
import MapKit

class MBHDB {
    
    static let sharedInstance = MBHDB()
    
    var MBHItems = [MBHItem]()

    //Items
    var MBHItemsMushrooms = [MBHItem]()
    var MBHItemsBerries = [MBHItem]()
    var MBHItemsHerbs = [MBHItem]()
    
    //Info items
    var MBHInfo = [MBHInfoItem]()
    
    //Map annotations
    var MBHAnnotations = [MBHItemAnnotation]()
    
    //UITableView offsets
    var mushroomsContentOffset: CGPoint
    var berriesContentOffset: CGPoint
    var herbsContentOffset: CGPoint
    var infoContentOffset: CGPoint
    
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
    var herbsEdibilityFilter: [UInt] = [1, 2, 3, 4, 5, 6]
    var herbsHarvestFilter: [Int] = [0, 1, 2, 3, 4]
    
    func wakeUp () {
        //Initialises singleton
    }
    
    private init() {
        //Reset content offsets
        mushroomsContentOffset = CGPoint(x: 0, y: 0)
        berriesContentOffset = CGPoint(x: 0, y: 0)
        herbsContentOffset = CGPoint(x: 0, y: 0)
        infoContentOffset = CGPoint(x: 0, y: 25)
        
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
            let count = try database.query("select count(*) as items_count from item")
        
            if count.affectedRowCount == 0 {
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
                
                //Get info items
                getInfoFromXML()
                
                //Inserting info items
                for item in MBHInfo {
                    let insertQuery = "insert into info_item (id, item_id, icon, title, title_advanced, text_1, text_2, text_3, text_4) values (null, \(item.id), '\(item.icon)', '\(item.title)', '\(item.titleAdvanced)', '\(item.text_1)', '\(item.text_2)', '\(item.text_3)', '\(item.text_4)')"
                    let _ = try database.query(insertQuery)
                }
            } else { //Get data from DB
                getItemsFromDB(category: 1)
                getItemsFromDB(category: 2)
                getItemsFromDB(category: 3)
                getInfoFromDB()
                getAnnotationsFromDB()
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
            if(category == 1) {
                MBHItemsMushrooms.sort(by: { $0.title < $1.title  })
            } else if(category == 2) {
                MBHItemsBerries.sort(by: { $0.title < $1.title  })
            } else if(category == 3) {
                MBHItemsHerbs.sort(by: { $0.title < $1.title  })
            }
        } catch {
            return
        }
    }
    
    func getInfoFromDB() {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            let resItems = try database.query("select * from info_item")
            
            for item in resItems.results! {
                let id = item["item_id"] as! Int
                let icon = item["icon"] as! String
                let title = item["title"] as! String
                let titleAdvanced = item["title_advanced"] as! String
                let text_1 = item["text_1"] as! String
                let text_2 = item["text_2"] as! String
                let text_3 = item["text_3"] as! String
                let text_4 = item["text_4"] as! String
            
                MBHInfo.append(MBHInfoItem(id: id, icon: icon, title: title, titleAdvanced: titleAdvanced, text_1: text_1, text_2: text_2, text_3: text_3, text_4: text_4))
            }
        } catch {
            return
        }
    }
    
    func getInfoFromXML() {
        guard let
            xmlPath = Bundle.main.path(forResource: "memo", ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
            else { return }
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            for item in xmlDoc.root["item"].all! {
                let id = Int(item["id"].value!)
                let icon = item["icon"].value!
                let title = item["title"].value!
                let titleAdvanced = item["title_advanced"].value!
                
                var text_1 = ""
                var text_2 = ""
                var text_3 = ""
                var text_4 = ""
                
                if let _ = item["text_1"].value {
                    text_1 = item["text_1"].value!
                }
                if let _ = item["text_2"].value {
                    text_2 = item["text_2"].value!
                }
                if let _ = item["text_3"].value {
                    text_3 = item["text_3"].value!
                }
                if let _ = item["text_4"].value {
                    text_4 = item["text_4"].value!
                }
                
                MBHInfo.append(MBHInfoItem(id: id!, icon: icon, title: title, titleAdvanced: titleAdvanced, text_1: text_1, text_2: text_2, text_3: text_3, text_4: text_4))
            }
        } catch {
            return
        }
    }
    
    func getAnnotationsFromDB() {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            let resItems =  try database.query("select * from map_point")
            
            if resItems.affectedRowCount != 0 {
                for item in resItems.results! {
                    let name = item["name"] as! String
                    let latitude = item["latitude"] as! Double
                    let longtitude = item["longitude"] as! Double
                    let uuid = item["uuid"] as! String
                    
                    MBHAnnotations.append(MBHItemAnnotation(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longtitude)), title: name, uuid: uuid))
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
                result = MBHItemsHerbs.filter({$0.isFavourite == 1 && herbsEdibilityFilter.contains($0.edibility_id)  && herbsHarvestFilter.contains($0.harvestData.getHarvestStatus())})
            } else {
                result = MBHItemsHerbs.filter({herbsEdibilityFilter.contains($0.edibility_id)  && herbsHarvestFilter.contains($0.harvestData.getHarvestStatus())})
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
    
    func saveAnnotationToDB(item: MBHItemAnnotation) {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            try _ = database.query("insert into map_point (id, name, latitude, longitude, uuid) values (null, '\(item.title!)', \(item.coordinate.latitude), \(item.coordinate.longitude), '\(item.uuid)')")
        } catch {
            return
        }
    }
    
    func deleteAnnotationFromDB(item: MBHItemAnnotation) {
        do {
            let database = try SQLitePool.manager().initialize(database: "MushBerHer", withExtension: "sqlite")
            try _ = database.query("delete from map_point where uuid = '\(item.uuid)'")
        } catch {
            return
        }
    }
}
