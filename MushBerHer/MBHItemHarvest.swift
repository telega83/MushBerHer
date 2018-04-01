//
//  MBHItemHarvest.swift
//  MushBerHer
//
//  Created by Oleg on 22/12/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import Foundation
import SQLiteManager

class MBHItemHarvest {
    //Ranges sets
    private var _startRanges = [[Int]]()
    private var _poorRanges = [[Int]]()
    private var _massRanges = [[Int]]()
    private var _endRanges = [[Int]]()
    
    var startRanges: [[Int]] {
        get {
            return _startRanges
        }
    }
    
    var poorRanges: [[Int]] {
        get {
            return _poorRanges
        }
    }
    
    var massRanges: [[Int]] {
        get {
            return _massRanges
        }
    }
    
    var endRanges: [[Int]] {
        get {
            return _endRanges
        }
    }
    
    //For XML data at the fisrt lauhcn
    init(startRanges: String, poorRanges: String, massRanges: String, endRanges: String) {
        _startRanges = convertRanges(rangesSet: startRanges)
        _poorRanges = convertRanges(rangesSet: poorRanges)
        _massRanges = convertRanges(rangesSet: massRanges)
        _endRanges = convertRanges(rangesSet: endRanges)
    }
    
    //For DB data
    init(rawData: SQLiteQueryResult) {
        for item in rawData.results! {
            if item["type"] as! Int == 1 {
                _startRanges.append([item["day_min"] as! Int, item["day_max"] as! Int])
            } else if item["type"] as! Int == 2 {
                _poorRanges.append([item["day_min"] as! Int, item["day_max"] as! Int])
            } else if item["type"] as! Int == 3 {
                _massRanges.append([item["day_min"] as! Int, item["day_max"] as! Int])
            } else if item["type"] as! Int == 4 {
                _endRanges.append([item["day_min"] as! Int, item["day_max"] as! Int])
            }
        }
    }
    
    //'month-decade -> day-day' convertion for all ranges in a separate set
    private func convertRanges(rangesSet: String) -> [[Int]] {
        //Split
        let ranges = rangesSet.split(separator: ",")
        
        if ranges.count != 0 {
            var result = [[Int]]()
            for range in ranges {
                result.append(calculateDaysRange(harvestRange: String(range)))
            }
            return result
        } else {
            return [[0,0]]
        }
    }
    
    //'month-decade -> day-day' convertion for one separate range
    private func calculateDaysRange(harvestRange: String) -> [Int] {
        //Split
        if let month = Int(harvestRange.split(separator: "-")[0]), let decade = Int(harvestRange.split(separator: "-")[1]) {
            if (month > 0) && (month <= 12) {
                //Current date
                let curDate = Date()
                
                //First day of range month
                var rangeMonthFirstComponents = DateComponents()
                rangeMonthFirstComponents.year = Calendar.current.component(.year, from: curDate)
                rangeMonthFirstComponents.month = month
                rangeMonthFirstComponents.day = 1
                let rangeMonth = Calendar.current.date(from: rangeMonthFirstComponents)
                
                //Days shift
                let shift =  Calendar.current.ordinality(of: .day, in: .year, for: rangeMonth!)
                
                //Decade range
                var decadeStart: Int = 0
                var decadeEnd: Int = 0
                
                if decade == 1 {
                    decadeStart = shift!
                    decadeEnd = shift! + 9
                } else if decade == 2 {
                    decadeStart = shift! + 10
                    decadeEnd = shift! + 19
                } else if decade == 3 {
                    decadeStart = shift! + 20
                    decadeEnd = shift! + (Calendar.current.range(of: .day, in: .month, for: rangeMonth!)!.count - 1)
                }
                return [decadeStart, decadeEnd]
            } else {
                return [0, 0]
            }
        } else {
            return [0, 0]
        }
    }
    
    func generateInsertHarvestQueries(itemId: UInt, categoryId: UInt) -> [String] {
        var result = [String]()
        
        //start
        var resultItem = String("")
        for range in _startRanges {
            resultItem = resultItem! + "insert into harvest (item_id, type, day_min, day_max, category_id) values (\(itemId), 1, \(range[0]), \(range[1]), \(categoryId));" + "|"
        }
        result.append(resultItem!)
        
        //poor
        resultItem = ""
        for range in _poorRanges {
            resultItem = resultItem! + "insert into harvest (item_id, type, day_min, day_max, category_id) values (\(itemId), 2, \(range[0]), \(range[1]), \(categoryId));" + "|"
        }
        result.append(resultItem!)
        
        //mass
        resultItem = ""
        for range in _massRanges {
            resultItem = resultItem! + "insert into harvest (item_id, type, day_min, day_max, category_id) values (\(itemId), 3, \(range[0]), \(range[1]), \(categoryId));" + "|"
        }
        result.append(resultItem!)
        
        //end
        resultItem = ""
        for range in _endRanges {
            resultItem = resultItem! + "insert into harvest (item_id, type, day_min, day_max, category_id) values (\(itemId), 4, \(range[0]), \(range[1]), \(categoryId));" + "|"
        }
        result.append(resultItem!)
        
        return result
    }
    
    // 0 - none
    // 1 - start
    // 2 - poor
    // 3 - mass
    // 4 - end
    func getHarvestStatus() -> Int {
        //Current day number
        if let curDay = Calendar.current.ordinality(of: .day, in: .year, for: Date()) {
            for range in _startRanges {
                if !range.isEmpty {
                    if (curDay >= range[0]) && (curDay <= range[1])  { return 1 }
                }
            }
            
            for range in _poorRanges {
                if !range.isEmpty {
                    if (curDay >= range[0]) && (curDay <= range[1])  { return 2 }
                }
            }
            
            for range in _massRanges {
                if !range.isEmpty {
                    if (curDay >= range[0]) && (curDay <= range[1])  { return 3 }
                }
            }
            
            for range in _endRanges {
                if !range.isEmpty {
                    if (curDay >= range[0]) && (curDay <= range[1])  { return 4 }
                }
            }
            return 0
        }
        return 0
    }
}
