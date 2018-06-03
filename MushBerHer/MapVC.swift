//
//  MapVC.swift
//  MushBerHer
//
//  Created by Oleg on 13/02/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchView: MapSearchView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationMager = CLLocationManager()
    let regionRadius: CLLocationDistance = 500
    
    var autoZoom: Bool = true
    var isSearching: Bool = false
    var filteredData = [MBHItem]()
    var resDataSet = [MBHItem]()
    
    @IBAction func btnCenterTapped(_ sender: Any) {
        let loc = CLLocation(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
        centerMapOnLocation(location: loc)
    }
    
    @IBAction func btnAddAnnotationTapped(_ sender: Any) {
        //createAnnotation(location: map.userLocation.coordinate, title: "Гриб!")
        searchView.isHidden = false
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        searchBar.endEditing(true)
        searchView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        restoreAnnotations()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        guard let annotation = annotation as? MBHItemAnnotation else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView {
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        view.animatesDrop = true
        view.canShowCallout = true
        
        let removeIcon = UIImage(named: "map_remove")
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btn.setImage(removeIcon, for: UIControlState.normal)
        view.rightCalloutAccessoryView = btn
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MBHItemAnnotation
        
        print(annotation.title)
        
        //Remove annotation from collection and from DB
        
    }
    
    func createAnnotation(location: CLLocationCoordinate2D, title: String) {
        let item = MBHItemAnnotation(coordinate: location, title: title)
        map.addAnnotation(item)
        MBHDB.sharedInstance.MBHAnnotations.append(item)
        MBHDB.sharedInstance.saveAnnotationToDB(item: item)
    }
    
    func restoreAnnotations() {
        for item in MBHDB.sharedInstance.MBHAnnotations {
            map.addAnnotation(item)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return MBHDB.sharedInstance.MBHItemsMushrooms.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mapSearchCell", for: indexPath) as? MapSearchTableViewCell {
            if isSearching {
                //User filtered data set
                resDataSet = filteredData
            } else {
                resDataSet = MBHDB.sharedInstance.MBHItemsMushrooms
            }
            
            cell.img.image = UIImage(named: "item_1_\(resDataSet[indexPath.row].id)_thumb")
            cell.lblTitle.text = resDataSet[indexPath.row].title
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        searchView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: false)
        createAnnotation(location: map.userLocation.coordinate, title: resDataSet[indexPath.row].title)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = MBHDB.sharedInstance.MBHItemsMushrooms.filter({$0.title.capitalized.range(of: searchBar.text!.capitalized) != nil || $0.title_advanced.capitalized.range(of: searchBar.text!.capitalized) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
