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
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var reviewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reviewerImage: UIImageView!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var reviewDetailView: UIView!
    
    var reviewerPhotos: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCafeIndex = Constants.SelectedCafe.Index {
            let venueID = Constants.SearchedCafes.CafeIDs[selectedCafeIndex]
            Constants.imageData = nil
            Constants.Cafe.reviews = nil
            Constants.Cafe.userNames = nil
            Constants.Cafe.userPhotoURLs = nil
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let reviews = Constants.Cafe.reviews {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")!
        if Constants.Cafe.reviews != nil {
            return configureCell(cell: cell, atIndexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = Constants.Cafe.userNames[indexPath.row]
        let content = Constants.Cafe.reviews[indexPath.row]
        let userImageData = reviewerPhotos[indexPath.row]
        reviewerImage.image = UIImage(data: userImageData)
        reviewerName.text = name
        review.text = content
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Function configureCell
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath)-> UITableViewCell {
        let review = Constants.Cafe.reviews[indexPath.row]
        let reviewerName = Constants.Cafe.userNames[indexPath.row]
        let reviewerImagePath = Constants.Cafe.userPhotoURLs[indexPath.row]
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: reviewerImagePath) { imageData in
            if imageData != nil {
                performUIUpdateOnMain {
                    cell.imageView?.image = UIImage(data: imageData!)
                    cell.textLabel?.text = reviewerName
                    cell.detailTextLabel?.text = review
                }
                self.reviewerPhotos.append(imageData!)
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
    
    // MARK: Function enableCafeReviews
    func enableCafeReviews(enable: Bool) {
        if enable {
            reviewsLabel.isHidden = true
            tableView.isHidden = false
            reviewActivityIndicator.stopAnimating()
            tableView.reloadData()
            reviewDetailView.isHidden = false
            reviewerName.text = Constants.Cafe.userNames.first
            review.text = Constants.Cafe.reviews.first
            FoursquareAPI.sharedInstance.downloadImages(atImagePath: Constants.Cafe.userPhotoURLs.first!) { imageData in
                if imageData != nil {
                    performUIUpdateOnMain {
                        self.reviewerImage.image = UIImage(data: imageData!)
                    }
                }
                else {
                    performUIUpdateOnMain {
                        self.reviewerImage.image = #imageLiteral(resourceName: "ReviewerPlaceholderImage")
                    }
                }
            }
        }
        else {
            reviewActivityIndicator.stopAnimating()
            reviewsLabel.text = "No Reviews Available"
        }
    }
    
}
