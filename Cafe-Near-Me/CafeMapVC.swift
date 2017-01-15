//
//  CafeMapViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 12/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import MapKit

class CafeMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCafeLocationOnMap()
        if let cafe = Constants.SelectedCafe.Index {
            let distance = Float(Constants.SearchedCafes.Distances[cafe]) / 1000
            let searchLocation = Constants.searchingLocation.capitalized
            distanceLabel.text = "Within \(distance) km From \(searchLocation)"
        }
    }
    
    // MARK: Function loadCafeLocationOnMap()
    
    func loadCafeLocationOnMap() {
        if let cafe = Constants.SelectedCafe.Index {
            let latitude = Constants.SearchedCafes.Latitudes[cafe]
            let longitude = Constants.SearchedCafes.Longitudes[cafe]
            let annotation = MKPointAnnotation()
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let cafeName = Constants.SearchedCafes.Names[cafe]
            let span = MKCoordinateSpanMake(0.09, 0.09)
            let region = MKCoordinateRegionMake(location, span)
            annotation.coordinate = location
            annotation.title = cafeName
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
        }
    }
    
}
