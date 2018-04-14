//
//  MBHInfoItem.swift
//  MushBerHer
//
//  Created by Oleg on 13/04/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation

class MBHInfoItem {
    
    private var _id: Int!
    private var _icon: String!
    private var _title: String!
    private var _titleAdvanced: String!
    private var _text_1: String!
    private var _text_2: String!
    private var _text_3: String!
    private var _text_4: String!
    
    var id: Int {
        get {
            return _id
        }
    }
    
    var icon: String {
        get {
            return _icon
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    var titleAdvanced: String {
        get {
            return _titleAdvanced
        }
    }
    
    var text_1: String {
        get {
            return _text_1
        }
    }
    
    var text_2: String {
        get {
            return _text_2
        }
    }
    
    var text_3: String {
        get {
            return _text_3
        }
    }
    
    var text_4: String {
        get {
            return _text_4
        }
    }
    
    init(id: Int, icon: String, title: String, titleAdvanced: String, text_1: String, text_2: String, text_3: String, text_4:String) {
        _id = id
        _icon = icon
        _title = title
        _titleAdvanced = titleAdvanced
        _text_1 = text_1
        _text_2 = text_2
        _text_3 = text_3
        _text_4 = text_4
    }
}
