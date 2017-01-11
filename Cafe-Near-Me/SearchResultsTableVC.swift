//
//  SearchResultsVC.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(enable: false)
        let searchLocation = Constants.searchingLocation.capitalized
        self.title = "Cafes In " + searchLocation
        if let LatLon = Constants.searchingLatLon {
            FoursquareAPI.sharedInstance.searchCafesForALocation(LatitudeAndLongitude: LatLon) { sucess, error in
                if sucess {
                    performUIUpdateOnMain {
                        self.configureUI(enable: true)
                        self.tableView.reloadData()
                    }
                }
                else {
                    performUIUpdateOnMain {
                        self.noResultsLabel.isHidden = false
                        self.noResultsLabel.text = "Sorry, No Cafes Found"
                        self.activityIndicator.stopAnimating()
                        self.displayAnAlert(title: "Searching Failed", message: error!)
                    }
                }
            }
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = Constants.searchedCafeNames {
            return searchResults.count
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = Constants.searchedCafeNames[indexPath.row]
        cell.detailTextLabel?.text = Constants.searchedCafeAddresses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.selectedCafeIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "TableViewToTabView", sender: self)
    }
    
    // MARK: Func configureUI
    func configureUI(enable: Bool) {
        if enable {
            tableView.isHidden = false
            noResultsLabel.isHidden = true
            activityIndicator.stopAnimating()
        }
        else {
            tableView.isHidden = true
            noResultsLabel.isHidden = false
            noResultsLabel.text = "Searching..."
            activityIndicator.startAnimating()
        }
    }

    // MARK: Cancel button action
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}