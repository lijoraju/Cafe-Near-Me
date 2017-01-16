//
//  CafeMapViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 12/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CafeMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loadingMapFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchingLatLon = Constants.searchingLatLon
        if (searchingLatLon != nil) {
            loadingMapFlag = true
            if let cafe = Constants.SelectedCafe.Index {
                let distance = Float(Constants.SearchedCafes.Distances[cafe]) / 1000
                let searchLocation = Constants.searchingLocation.capitalized
                distanceLabel.text = "Within \(distance) km From \(searchLocation)"
            }
        }
        else {
            let cafe = CoreData.sharedInstance.gettingCafeInfo(managedObjectContext: managedContext)
            let distance = Float(cafe.distance) / 1000
            let nearLocation = cafe.nearLocation!
            distanceLabel.text = "Within \(distance) km From \(nearLocation)"
        }
        loadCafeLocationOnMap()
    }
    
    // MARK: Function loadCafeLocationOnMap()
    func loadCafeLocationOnMap() {
        var latitude: Double!
        var longitude: Double!
        var cafeName: String!
        if loadingMapFlag {
            if let cafe = Constants.SelectedCafe.Index {
                latitude = Constants.SearchedCafes.Latitudes[cafe]
                longitude = Constants.SearchedCafes.Longitudes[cafe]
                cafeName = Constants.SearchedCafes.Names[cafe]
            }
        }
        else {
            let cafe = CoreData.sharedInstance.gettingCafeInfo(managedObjectContext: managedContext)
            latitude = cafe.latitude
            longitude = cafe.longitude
            cafeName = cafe.name
        }
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.09, 0.09)
        let region = MKCoordinateRegionMake(location, span)
        annotation.coordinate = location
        annotation.title = cafeName
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
}
