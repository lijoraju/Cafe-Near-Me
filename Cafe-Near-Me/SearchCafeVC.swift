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
    
    // MARK: Function getLatLonForLocation()
    func getLatLonForLocation() {
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    // MARK: Function processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?)
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
    
    // MARK: Function completeSearchForCafes()
    func completeSearchForCafes() {
        configureUI(enable: true)
        performSegue(withIdentifier: "SearchToResult", sender: self)
    }
    
    // MARK: Function configureUI(enable: Bool)
    func configureUI(enable: Bool) {
        if enable {
            locationTextField.isEnabled = true
            searchButton.isEnabled = true
            activityIndicator.stopAnimating()
        }
        else {
            locationTextField.isEnabled = false
            searchButton.isEnabled = false
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: Function keyboardWillShow(_ notification: NSNotification)
    func keyboardWillShow(_ notification: NSNotification) {
        if locationTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // MARK : Function keyboardWillHide(_ notification: NSNotification)
    func keyboardWillHide(_ notification: NSNotification) {
        if locationTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        
    }
    
    // MARK: Function subscribeToKeyboardNotifications()
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCafeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCafeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Function unsubscribeToKeyboardNotifications(
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Function getKeyboardHeight(_ notification: NSNotification)-> CGFloat
    func getKeyboardHeight(_ notification: NSNotification)-> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Function hideKeyboardWhenTappedAround()
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
    
    // MARK: Bookmarks Button Action
    @IBAction func showAllBookmarks(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToBookmarks", sender: self)
    }
    
}

// MARK: Extension UIViewController
extension UIViewController {
    
    // MARK: Function displayAnAlert(title: String, message: String)
    func  displayAnAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}
