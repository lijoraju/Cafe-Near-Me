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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
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
    
    // Shift the view's frame up from when keyboard appears
    func keyboardWillShow(_ notification: NSNotification) {
        if locationTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // Shift the view's frame down from when keyboard disappears
    func keyboardWillHide(_ notification: NSNotification) {
        if locationTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        
    }
    
    // MARK: Subscribe keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCafeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCafeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Unsubscribe keyboard notifications
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Obtain keyboard height
    func getKeyboardHeight(_ notification: NSNotification)-> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Close keyboard by touching anywhere
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchCafeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
        locationTextField.resignFirstResponder()
        return true
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
