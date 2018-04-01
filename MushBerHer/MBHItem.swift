//
//  MBHItem.swift
//  MushBerHer
//
//  Created by Oleg on 28/05/2017.
//  Copyright © 2017 telega. All rights reserved.
//

import Foundation

class MBHItem {
    
    private var _id: UInt!
    private var _category_id: UInt!
    private var _edibility_id: UInt!
    private var _title: String!
    private var _title_advanced: String!
    private var _additional: String!
    private var _prologue:String!
    private var _text: String!
    private var _notes: String?
    private var _harvestData: MBHItemHarvest
    private var _isFavourite: Int!
    
    var id: UInt {
        get {
            return _id
        }
    }
    
    var category_id: UInt {
        get {
            return _category_id
        }
    }
    
    var edibility_id: UInt {
        get {
            return _edibility_id
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    var title_advanced: String {
        get {
            return _title_advanced
        }
    }
    
    var additional: String {
        get {
            return _additional
        }
    }
    
    var prologue: String {
        get {
            return _prologue
        }
    }
    
    var text: String {
        get {
            return _text
        }
    }
    
    var notes: String {
        get {
            return _notes!
        }
    }
    
    var harvestData: MBHItemHarvest {
        get {
            return _harvestData
        }
    }
    
    var isFavourite: Int {
        get {
            return _isFavourite
        }
        set {
            _isFavourite = newValue
        }
    }
    
    init (id: UInt,
          category_id: UInt,
          edibility_id: UInt,
          title: String,
          title_advanced: String,
          additional: String,
          prologue: String,
          text: String,
          notes: String,
          harvestData: MBHItemHarvest,
          isFavourite: Int) {
     
        _id = id
        _category_id = category_id
        _edibility_id = edibility_id
        _title = title
        _title_advanced = title_advanced
        _additional = additional
        _prologue = prologue
        _text = text
        _notes = notes
        _harvestData = harvestData
        _isFavourite = isFavourite
    }
}
