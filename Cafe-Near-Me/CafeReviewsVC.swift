//
//  ReviewDetailsViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 09/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class CafeReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
            Constants.SelectedCafeReviews.reviews = nil
            Constants.SelectedCafeReviews.userNames = nil
            Constants.SelectedCafeReviews.userPhotoURLs = nil
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
                    FoursquareAPI.sharedInstance.getVenueReviews(selectedVenueID: venueID) { sucess, errorString in
                        if sucess {
                            performUIUpdateOnMain {
                                self.tableView.reloadData()
                            }
                        }
                        else {
                            performUIUpdateOnMain {
                                self.displayAnAlert(title: "Error", message: errorString!)
                            }
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
        if let reviews = Constants.SelectedCafeReviews.reviews {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")!
        if Constants.SelectedCafeReviews.reviews != nil {
            return configureCell(cell: cell, atIndexPath: indexPath)
        }
        return cell
    }
    
    // MARK: Funs configureCell
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath)-> UITableViewCell {
        let review = Constants.SelectedCafeReviews.reviews[indexPath.row]
        let reviewerName = Constants.SelectedCafeReviews.userNames[indexPath.row]
        let reviewerImagePath = Constants.SelectedCafeReviews.userPhotoURLs[indexPath.row]
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: reviewerImagePath) { imageData, errorString in
            if imageData != nil {
                performUIUpdateOnMain {
                    cell.imageView?.image = UIImage(data: imageData!)
                    cell.textLabel?.text = reviewerName
                    cell.detailTextLabel?.text = review
                }
            }
            else {
                performUIUpdateOnMain {
                    cell.textLabel?.text = reviewerName
                    cell.detailTextLabel?.text = review
                }
            }
        }
        return cell
    }
    
}
