//
//  MBHItemAnnotation.swift
//  MushBerHer
//
//  Created by Oleg on 09/05/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation
import MapKit

class MBHItemAnnotation: NSObject, MKAnnotation {
    var identifier = "item"
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
