//
//  MapVC.swift
//  MushBerHer
//
//  Created by Oleg on 13/02/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchView: FilterMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationMager = CLLocationManager()
    let regionRadius: CLLocationDistance = 500
    
    var autoZoom: Bool = true
    
    @IBAction func btnCenterTapped(_ sender: Any) {
        let loc = CLLocation(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
        centerMapOnLocation(location: loc)
    }
    
    @IBAction func btnAddAnnotationTapped(_ sender: Any) {
        //createAnnotation(location: map.userLocation.coordinate, title: "Гриб!")
        searchView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationMager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if autoZoom {
                centerMapOnLocation(location: loc)
                autoZoom = false
            }
        }
    }
    
    func createAnnotation(location: CLLocationCoordinate2D, title: String) {
        let item = MBHItemAnnotation(coordinate: location, title: title)
        map.addAnnotation(item)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MBHDB.sharedInstance.MBHItemsMushrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mapSearchCell", for: indexPath) as? UITableViewCell {
            
            cell.textLabel?.text = MBHDB.sharedInstance.MBHItemsMushrooms[indexPath.row].title
            
            return cell
        }
    }

}
