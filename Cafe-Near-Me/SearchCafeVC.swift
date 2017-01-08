//
//  ViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import CoreLocation

class SearchCafeViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    // MARK: Search button action
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        configureUI(enable: false)
        if locationTextField.text != "" {
            Constants.searchingLocation = locationTextField.text
            getLatLonForLocation()
        }
        else {
            configureUI(enable: true)
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
            configureUI(enable: true)
            displayAnAlert(title: "Error", message: error.localizedDescription)
        }
        else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let coordinates = location.coordinate
                let latitude = coordinates.latitude
                let longitude = coordinates.longitude
                Constants.searchingLatLon = "\(latitude),\(longitude)"
                completeSearchForCafes()
            }
        }
    }
    
    // MARK: Func completeSearchForCafes
    func completeSearchForCafes() {
        configureUI(enable: true)
        performSegue(withIdentifier: "SearchToResult", sender: self)
    }
    
    // MARK: Func configureUI 
    func configureUI(enable: Bool) {
        if enable {
            searchButton.isEnabled = true
            activityIndicator.stopAnimating()
        }
        else {
            searchButton.isEnabled = false
            activityIndicator.startAnimating()
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
