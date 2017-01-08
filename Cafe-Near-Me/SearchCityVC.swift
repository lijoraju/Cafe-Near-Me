//
//  ViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import CoreLocation

class SearchCityViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    // MARK: Search button action
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        if locationTextField.text != "" {
            getLatLonForLocation()
        }
        else {
            displayAnAlert(title: "Alert", message: "No location specified. Type your desired location")
        }
    }
    
    // MARK: Func getLatLonForLocation finding coordinates for search location
    func getLatLonForLocation() {
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    // MARK: Func processResponse process response from CLGeocoder
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            displayAnAlert(title: "Error", message: error.localizedDescription)
        }
        else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let coordinates = location.coordinate
                print("Lat = \(coordinates.latitude) and lon = \(coordinates.longitude)")
            }
        }
    }
    
    
}

// MARK: Extension UIViewController
extension UIViewController {
    
    // MARK: Displaying an alert
    func  displayAnAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}
