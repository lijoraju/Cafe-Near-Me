//
//  CafeViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 14/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import CoreData

class CafeViewController: UIViewController {
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UITextView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadingLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var cafeOpenedLabel: UILabel!
    @IBOutlet weak var cafeOpenHours: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequestForPhoto: NSFetchRequest<Photo> = Photo.fetchRequest()
    var cafes: [Cafe] = []
    var cafePhotos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchingLatLon = Constants.searchingLatLon
        if (searchingLatLon != nil) {
            gettingPhotoForTheCafe()
            gettingDetailsForTheCafe()
        }
        else {
            getPhotoAndDetailsFromBookmarks()
        }
    }
    
    // MARK: Function showCafeDetailsAndPhoto(cafeIndex: Int)
    func showCafeDetailsAndPhoto() {
        let cafe = CoreData.sharedInstance.gettingCafeInfo(managedObjectContext: managedContext)
        cafeName.text = cafe.name
        cafeAddress.text = cafe.address
        ratingLabel.text = "Rating : \(cafe.rating) / 10.0"
        ratingLabel.isHidden = false
        imageLoadingIndicator.stopAnimating()
        if cafePhotos.count == 0 {
            imageLoadingLabel.text = "No Photo Available"
        }
        else {
            let photo = cafePhotos.first
            let photoData = photo?.photoData
            cafeImage.image = UIImage(data: photoData as! Data)
        }
    }
    
    // MARK: Function getPhotoAndDetailsFromBookmarks(forIndex index: Int)
    func getPhotoAndDetailsFromBookmarks() {
        let cafe = CoreData.sharedInstance.gettingCafeInfo(managedObjectContext: managedContext)
        let predicate: NSPredicate = NSPredicate(format: "cafe = %@", cafe)
        fetchRequestForPhoto.predicate = predicate
        do {
            cafePhotos = try managedContext.fetch(fetchRequestForPhoto)
        }
        catch let error as NSError {
            print("Failed fetching cafe photos \(error) \(error.userInfo)")
        }
        showCafeDetailsAndPhoto()
    }
    
    // MARK: Function gettingPhotoForTheCafe()
    func gettingPhotoForTheCafe() {
        if let cafe = Constants.SelectedCafe.Index {
                let venueID = Constants.SearchedCafes.VenueIDs[cafe]
                FoursquareAPI.sharedInstance.getVenuePhotos(selectedVenueID: venueID) { sucess, errorString in
                    if sucess {
                        guard let cafePhotoURL = Constants.Cafe.photoURLs.first else {
                            performUIUpdateOnMain {
                                self.imageLoadingIndicator.stopAnimating()
                                self.imageLoadingLabel.text = "No Photo Available"
                            }
                            return
                        }
                        FoursquareAPI.sharedInstance.downloadImages(atImagePath: cafePhotoURL) { imageData in
                            if imageData != nil {
                                performUIUpdateOnMain {
                                    self.imageLoadingIndicator.stopAnimating()
                                    self.imageLoadingLabel.isHidden = true
                                    self.cafeImage.image = UIImage(data: imageData!)
                                }
                            }
                            else {
                                performUIUpdateOnMain {
                                    self.imageLoadingIndicator.stopAnimating()
                                    self.imageLoadingLabel.text = "Loading Photo Failed!"
                                }
                            }
                            Constants.Cafe.photo = imageData
                        }
                    }
                    else {
                        performUIUpdateOnMain {
                            self.imageLoadingIndicator.stopAnimating()
                            self.imageLoadingLabel.text = "Loading Photo Failed!"
                            self.displayAnAlert(title: "Error: Downloading Cafe Photo", message: errorString!)
                        }
                    }
                }
        }
    }
    
    // MARK: Function gettingDetailsForTheCafe()
    func gettingDetailsForTheCafe() {
            if let cafe = Constants.SelectedCafe.Index {
                let venueID = Constants.SearchedCafes.VenueIDs[cafe]
                cafeName.text = Constants.SearchedCafes.Names[cafe]
                cafeAddress.text = "Address : \(Constants.SearchedCafes.Addresses[cafe])"
                FoursquareAPI.sharedInstance.getVenueDetails(selectedVenueID: venueID) { sucess in
                    if sucess {
                        let rating = "\(Constants.Cafe.rating)"
                        performUIUpdateOnMain {
                            self.ratingLabel.isHidden = false
                            self.ratingLabel.text = "Rating : \(rating) / 10.0"
                        }
                    }
                }
                FoursquareAPI.sharedInstance.getVenueOpenHours(selectedVenueID: venueID) { sucess in
                    if sucess {
                        if let opensToday = Constants.Cafe.openToday {
                            if opensToday {
                                performUIUpdateOnMain {
                                    self.cafeOpenedLabel.isHidden = false
                                    self.cafeOpenedLabel.text = "Open Today"
                                }
                            }
                            else {
                                performUIUpdateOnMain {
                                    self.cafeOpenedLabel.isHidden = false
                                    self.cafeOpenedLabel.text = "Close Today"
                                }
                            }
                        }
                        if let openingHours = Constants.Cafe.openTimeframe {
                            performUIUpdateOnMain {
                                self.cafeOpenHours.isHidden = false
                                self.cafeOpenHours.text = openingHours
                            }
                        }
                    }
                }
            }
    }
    
    // MARK: Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Action for Bookmark button
    @IBAction func bookmarkButtonAction(_ sender: AnyObject) {
        if let selectedCafe = Constants.SelectedCafe.Index {
            let cafe = Cafe(context: managedContext)
            cafe.venueID = Constants.SearchedCafes.VenueIDs[selectedCafe]
            cafe.name = Constants.SearchedCafes.Names[selectedCafe]
            cafe.address = Constants.SearchedCafes.Addresses[selectedCafe]
            cafe.distance = Int16(Constants.SearchedCafes.Distances[selectedCafe])
            cafe.latitude = Constants.SearchedCafes.Latitudes[selectedCafe]
            cafe.longitude = Constants.SearchedCafes.Longitudes[selectedCafe]
            cafe.rating = Constants.Cafe.rating
            cafe.nearLocation = Constants.searchingLocation
            CoreData.sharedInstance.save(managedObjectContext: managedContext) { sucess in
                if sucess {
                    print("Cafe added to bookmarks")
                    self.addCafePhotosToBookmarks(forCafe: cafe)
                }
                else {
                    performUIUpdateOnMain {
                        self.displayAnAlert(title: "Error", message: "Failed bookmarking cafe")
                    }
                }
            }
        }
    }
    
    // MARK: Function addCafePhotosToBookmarks(forCafe thisCafe: Cafe)
    func addCafePhotosToBookmarks(forCafe thisCafe: Cafe) {
        if let photoURLs = Constants.Cafe.photoURLs {
            for url in photoURLs {
                FoursquareAPI.sharedInstance.downloadImages(atImagePath: url) { photoData in
                    if photoData != nil {
                        performUIUpdateOnMain {
                            let photo = Photo(context: self.managedContext)
                            photo.photoURL = url
                            photo.photoData = photoData as NSData?
                            photo.cafe = thisCafe
                            CoreData.sharedInstance.save(managedObjectContext: self.managedContext) { sucess in
                                if sucess {
                                    print("Bookmarked a cafe photo")
                                }
                            }
                        }
                    }
                }
            }
            addCafeReviewsToBookmarks(forCafe: thisCafe)
        }
    }
    
    // MARK: Function addCafeReviewsToBookmarks(forCafe thisCafe: Cafe)
    func addCafeReviewsToBookmarks(forCafe thisCafe: Cafe) {
        let reviews = Constants.Cafe.reviews
        if (reviews == nil) {
            getReviewsForTheCafe(forCafe: thisCafe)
        }
        else {
            let totalReviews = (Constants.Cafe.reviews).count - 1
            for index in 0...totalReviews {
                let cafeReview = Review(context: managedContext)
                cafeReview.review = Constants.Cafe.reviews[index]
                cafeReview.reviewer = Constants.Cafe.reviewerNames[index]
                cafeReview.cafe = thisCafe
                CoreData.sharedInstance.save(managedObjectContext: managedContext) { sucess in
                    if sucess {
                        print("Bookmarked a cafe review")
                        self.addReviewerPhotosToBookmarks(atIndex: index, forReview: cafeReview)
                    }
                }
            }
        }
    }
    
    // MARK: Function getReviewsForTheCafe(cafeVenueID: String)
    func getReviewsForTheCafe(forCafe thisCafe: Cafe) {
        FoursquareAPI.sharedInstance.getVenueReviews(selectedVenueID: thisCafe.venueID!) { sucess, errorString in
            if sucess {
                performUIUpdateOnMain {
                    self.addCafeReviewsToBookmarks(forCafe: thisCafe)
                }
            }
            else {
                performUIUpdateOnMain {
                    self.displayAnAlert(title: "Failed Bookmarking Cafe Reviews", message: errorString!)
                }
            }
        }
    }
    
    // MARK: Function addReviewerPhotosToBookmarks(atIndex index: Int, forReview: Review)
    func addReviewerPhotosToBookmarks(atIndex index: Int, forReview review: Review) {
        let url = Constants.Cafe.reviewerPhotoURLs[index]
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: url) { imageData in
            if imageData != nil {
                performUIUpdateOnMain {
                    let photo = Photo(context: self.managedContext)
                    photo.photoURL = url
                    photo.photoData = imageData! as NSData?
                    photo.review = review
                    CoreData.sharedInstance.save(managedObjectContext: self.managedContext) { sucess in
                        if sucess {
                            print("Bookmarked a reviewer photo")
                        }
                    }
                }
            }
        }
    }
    
}
