//
//  ReviewDetailsViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 09/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class ReviewDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingCafeImageLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCafeIndex = Constants.selectedCafeIndex {
            let venueID = Constants.searchedCafeIDs[selectedCafeIndex]
            cafeNameLabel.text = Constants.searchedCafeNames[selectedCafeIndex]
            cafeAddressLabel.text = Constants.searchedCafeAddresses[selectedCafeIndex]
            Constants.imageData = nil
            FoursquareAPI.sharedInstance.getVenuePhotos(selectedVenueID: venueID) { sucess, errorString in
                if sucess {
                    if Constants.imageData != nil {
                        performUIUpdateOnMain {
                            self.loadingCafeImageLabel.isHidden = true
                            self.cafeImage.isHidden = false
                            self.cafeImage.image = UIImage(data: Constants.imageData)
                        }
                    }
                    else {
                        performUIUpdateOnMain {
                            self.loadingCafeImageLabel.text = "No Image Available"
                        }
                    }
                }
                else {
                    self.displayAnAlert(title: "Error", message: errorString!)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")!
        return cell
    }
    
    
}
