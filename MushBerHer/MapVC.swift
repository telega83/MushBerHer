//
//  MapVC.swift
//  MushBerHer
//
//  Created by Oleg on 13/02/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: 56.00, longitude: 37.00, zoom: 10.0)
        mapView.camera = camera
        
        
        
    }

    
    /*
    override func loadView() {
        //let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        //let gmsMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    
        //view = gmsMapView
        
        //view.addSubview(mapView)
        //view = mapView
        
        /*let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView*/
    }
     */


}
