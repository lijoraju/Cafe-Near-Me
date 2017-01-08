//
//  SearchResultsVC.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let LatLon = Constants.searchingLatLon {
            FoursquareAPI.sharedInstance.searchCafesForALocation(LatitudeAndLongitude: LatLon) { sucess, error in
                if sucess {
                    self.configureUI(enable: true)
                    self.tableView.reloadData()
                }
                else {
                    self.configureUI(enable: true)
                    self.displayAnAlert(title: "Searching Failed", message: error!)
                }
            }
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        configureUI(enable: false)
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
        return cell
    }
    
    // MARK: Func configureUI
    func configureUI(enable: Bool) {
        if enable {
            tableView.isHidden = false
            activityIndicator.stopAnimating()
        }
        else {
            tableView.isHidden = true
            activityIndicator.startAnimating()
        }
    }

    
}
