//
//  CafeViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 14/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class CafeViewController: UIViewController {
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UITextView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCafePhoto()
    }
    
    // MARK: Function showCafePhoto()
    
    func showCafePhoto() {
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
            cafeName.text = Constants.SearchedCafes.Names[cafe]
            cafeAddress.text = Constants.SearchedCafes.Addresses[cafe]
        }
    }
    
}
