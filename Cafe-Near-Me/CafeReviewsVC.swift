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
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reviewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCafeIndex = Constants.SelectedCafe.Index {
            let venueID = Constants.SearchedCafes.CafeIDs[selectedCafeIndex]
            cafeNameLabel.text = Constants.SearchedCafes.Names[selectedCafeIndex]
            cafeAddressLabel.text = Constants.SearchedCafes.Addresses[selectedCafeIndex]
            Constants.imageData = nil
            Constants.SelectedCafeReviews.reviews = nil
            Constants.SelectedCafeReviews.userNames = nil
            Constants.SelectedCafeReviews.userPhotoURLs = nil
            FoursquareAPI.sharedInstance.getVenuePhotos(selectedVenueID: venueID) { sucess, errorString in
                if sucess {
                    if Constants.imageData != nil {
                        performUIUpdateOnMain {
                            self.enableCafeImage(enable: true)
                        }
                    }
                    else {
                        performUIUpdateOnMain {
                            self.enableCafeImage(enable: false)
                        }
                    }
                    FoursquareAPI.sharedInstance.getVenueReviews(selectedVenueID: venueID) { sucess, errorString in
                        if sucess {
                            performUIUpdateOnMain {
                                self.enableCafeReviews(enable: true)
                            }
                        }
                        else {
                            performUIUpdateOnMain {
                                self.displayAnAlert(title: "Error", message: errorString!)
                                self.enableCafeReviews(enable: false)
                            }
                        }
                    }
                }
                else {
                    self.displayAnAlert(title: "Error", message: errorString!)
                    self.enableCafeImage(enable: false)
                    self.enableCafeReviews(enable: false)
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
    
    // MARK: Func enableCafeImage
    func enableCafeImage(enable: Bool) {
        if enable {
            loadingCafeImageLabel.isHidden = true
            imageActivityIndicator.stopAnimating()
            cafeImage.isHidden = false
            cafeImage.image = UIImage(data: Constants.imageData)
        }
        else {
            loadingCafeImageLabel.text = "No Image Available"
            imageActivityIndicator.stopAnimating()
        }
    }
    
    // MARK: Func enableCafeReviews
    func enableCafeReviews(enable: Bool) {
        if enable {
            reviewsLabel.isHidden = true
            tableView.isHidden = false
            reviewActivityIndicator.stopAnimating()
            tableView.reloadData()
        }
        else {
            reviewActivityIndicator.stopAnimating()
            reviewsLabel.text = "No Reviews Available"
        }
    }
    
}
