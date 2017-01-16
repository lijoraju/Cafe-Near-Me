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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequestForCafe: NSFetchRequest<Cafe> = Cafe.fetchRequest()
    let fetchRequestForPhoto: NSFetchRequest<Photo> = Photo.fetchRequest()
    var cafes: [Cafe] = []
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchingLatLon = Constants.searchingLatLon
        if (searchingLatLon != nil) {
            showPhotoForThisCafe()
            showDetailsForThisCafe()
        }
        else {
            if let cafeIndex = Constants.SelectedCafe.Index {
                fetchDetailsAndPhotoFromBookmarks(forIndex: cafeIndex)
            }
        }
    }
    
    // MARK: Function showCafeDetailsAndPhoto(cafeIndex: Int)
    
    func showCafeDetailsAndPhoto(cafeIndex: Int) {
        let cafe = cafes[cafeIndex]
        let cafePhoto = photos.first!
        let photoData = cafePhoto.photoData
        cafeName.text = cafe.name
        cafeAddress.text = cafe.address
        imageLoadingIndicator.stopAnimating()
        imageLoadingLabel.isHidden = true
        cafeImage.image = UIImage(data: photoData as! Data)
        
    }
    
    // MARK: Function fetchDetailsAndPhotoFromBookmarks(forIndex index: Int)
    
    func fetchDetailsAndPhotoFromBookmarks(forIndex index: Int) {
        do {
            cafes = try managedContext.fetch(fetchRequestForCafe)
        }
        catch let error as NSError {
            print("Failed fetching cafe details \(error) \(error.userInfo)")
        }
        let predicate: NSPredicate = NSPredicate(format: "cafe = %@", cafes[index])
        fetchRequestForPhoto.predicate = predicate
        do {
            photos = try managedContext.fetch(fetchRequestForPhoto)
        }
        catch let error as NSError {
            print("Failed fetching cafe photos \(error) \(error.userInfo)")
        }
        showCafeDetailsAndPhoto(cafeIndex: index)
    }
    
    // MARK: Function showPhotoForThisCafe()
    
    func showPhotoForThisCafe() {
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
    
    // MARK: Function showDetailsForThisCafe()
    
    func showDetailsForThisCafe() {
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
    
    // MARK: Bookmark Button Action
    
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
            CoreData.sharedInstance.save(managedObjectContext: managedContext) { sucess in
                if sucess {
                    print("Cafe added to bookmarks")
                    self.bookmarkCafePhotos(forCafe: cafe)
                }
            }
        }
    }
    
    // MARK: Function bookmarkCafePhotos()
    
    func bookmarkCafePhotos(forCafe thisCafe: Cafe) {
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
                                    print("downloaded and saved photo from \(url)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
