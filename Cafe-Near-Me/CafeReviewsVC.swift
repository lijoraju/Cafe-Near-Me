//
//  ReviewDetailsViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 09/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import CoreData

class CafeReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var reviewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reviewerImage: UIImageView!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var reviewDetailView: UIView!
    
    var reviewerPhotos: [Data] = []
    var loadedReviews: Bool = false
    let managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
    var loadingReviewsFlag: Bool = false
    var bookmarkedReviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchingLatLon = Constants.searchingLatLon
        if (searchingLatLon != nil) {
            showAllReviewsForThisCafe()
        }
        else {
            showAllBookmarkedReviewsForTheCafe()
        }
    }
    
    // MARK: Function showAllReviewsForThisCafe()
    func showAllReviewsForThisCafe() {
        loadingReviewsFlag = true
        if let cafe = Constants.SelectedCafe.Index {
            let venueID = Constants.SearchedCafes.VenueIDs[cafe]
            FoursquareAPI.sharedInstance.getVenueReviews(selectedVenueID: venueID) { sucess, errorString in
                if sucess {
                    performUIUpdateOnMain {
                        self.enableCafeReviews(enable: true)
                    }
                }
                else {
                    performUIUpdateOnMain {
                        self.displayAnAlert(title: "Failed Loading Cafe Reviews", message: errorString!)
                        self.enableCafeReviews(enable: false)
                    }
                }
            }
        }
    }
    
    // MARK: Function showAllBookmarkedReviewsForTheCafe() 
    func showAllBookmarkedReviewsForTheCafe() {
        let cafe = CoreData.sharedInstance.gettingCafeInfo(managedObjectContext: managedContext, forDeleting: false, venueID: nil)
        let predicate: NSPredicate = NSPredicate(format: "cafe = %@", cafe)
        fetchRequest.predicate = predicate
        do {
            bookmarkedReviews = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Error fetching reviews \(error) \(error.userInfo)")
        }
        if bookmarkedReviews.count == 0 {
            reviewsLabel.text = "No Reviews Available"
            reviewActivityIndicator.stopAnimating()
        }
        else {
            reviewsLabel.isHidden = true
            tableView.isHidden = false
            reviewActivityIndicator.stopAnimating()
            tableView.reloadData()
            reviewDetailView.isHidden = false
            let firstReview = bookmarkedReviews.first!
            reviewerName.text = firstReview.reviewer
            review.text = firstReview.review
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadingReviewsFlag {
            if let reviews = Constants.Cafe.reviews {
                return reviews.count
            }
        }
        return bookmarkedReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")!
        if loadedReviews {
            let reviewerName = Constants.Cafe.reviewerNames[indexPath.row]
            let review = Constants.Cafe.reviews[indexPath.row]
            cell.imageView?.image = UIImage(data: reviewerPhotos[indexPath.row])
            cell.textLabel?.text = reviewerName
            cell.detailTextLabel?.text = review
            return cell
        }
        else {
            if loadingReviewsFlag {
                return configureCell(cell: cell, atIndexPath: indexPath)
            }
            let cafeReview = bookmarkedReviews[indexPath.row]
            let reviewerPhoto = cafeReview.photo!
            let photoData = reviewerPhoto.photoData
            cell.imageView?.image = UIImage(data: photoData as! Data)
            cell.textLabel?.text = cafeReview.reviewer
            cell.detailTextLabel?.text = cafeReview.review
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loadingReviewsFlag {
            let name = Constants.Cafe.reviewerNames[indexPath.row]
            let content = Constants.Cafe.reviews[indexPath.row]
            let userImageData = reviewerPhotos[indexPath.row]
            reviewerImage.image = UIImage(data: userImageData)
            reviewerName.text = name
            review.text = content
        }
        else {
            let cafeReview = bookmarkedReviews[indexPath.row]
            let reviewerPhoto = cafeReview.photo!
            let photoData = reviewerPhoto.photoData
            reviewerImage.image = UIImage(data: photoData as! Data)
            reviewerName.text = cafeReview.reviewer
            review.text = cafeReview.review
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Function configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath)-> UITableViewCell
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath)-> UITableViewCell {
        let review = Constants.Cafe.reviews[indexPath.row]
        let reviewerName = Constants.Cafe.reviewerNames[indexPath.row]
        let reviewerImagePath = Constants.Cafe.reviewerPhotoURLs[indexPath.row]
        let totalNumReviewerPhotos = Constants.Cafe.reviewerPhotoURLs.count
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: reviewerImagePath) { imageData in
            if imageData != nil {
                performUIUpdateOnMain {
                    cell.imageView?.image = UIImage(data: imageData!)
                    cell.textLabel?.text = reviewerName
                    cell.detailTextLabel?.text = review
                }
                self.reviewerPhotos.append(imageData!)
                if self.reviewerPhotos.count == totalNumReviewerPhotos {
                    Constants.Cafe.reviewerPhotos = self.reviewerPhotos
                    performUIUpdateOnMain {
                        self.completedLoadingPhotos()
                    }
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
    
    // MARK: Function enableCafeReviews(enable: Bool)
    func enableCafeReviews(enable: Bool) {
        DisplayingReviews: if enable {
            if Constants.Cafe.reviews.count == 0 {
                reviewsLabel.text = "No Reviews Available"
                reviewActivityIndicator.stopAnimating()
                break DisplayingReviews
            }
            reviewsLabel.isHidden = true
            tableView.isHidden = false
            reviewActivityIndicator.stopAnimating()
            tableView.reloadData()
            reviewDetailView.isHidden = false
            reviewerName.text = Constants.Cafe.reviewerNames.first
            review.text = Constants.Cafe.reviews.first
            FoursquareAPI.sharedInstance.downloadImages(atImagePath: Constants.Cafe.reviewerPhotoURLs.first!) { imageData in
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
            reviewsLabel.text = "Loading Reviews Failed!"
        }
    }
    
    // MARK: Function completedLoadingReviews()
    func completedLoadingPhotos() {
        loadedReviews = true
        tableView.reloadData()
    }
    
}
