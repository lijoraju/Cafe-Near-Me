//
//  CafePhotosViewController.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 14/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit

class CafePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cafePhoto: UIImageView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    @IBOutlet weak var noPhotosLabel: UILabel!
    @IBOutlet weak var photoLoadingIndicator: UIActivityIndicatorView!
    
    var Photos: [Data] = []
    var downloadedPhotos: Bool = false
    let itemsPerRow: CGFloat = 4
    let sectionInsects = UIEdgeInsets(top: 5, left: -17, bottom: 5, right: -17)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllPhotosForThisCafe()
        flowlayout.minimumLineSpacing = 3.0
        flowlayout.minimumInteritemSpacing = 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = Constants.Cafe.photoURLs {
            return photos.count
        }
        return 0
    }

    // MARK: Function showAllPhotosForThisCafe()
    func showAllPhotosForThisCafe() {
        guard Constants.Cafe.photo == nil else {
            photoLoadingIndicator.stopAnimating()
            noPhotosLabel.isHidden = true
            cafePhoto.image = UIImage(data: Constants.Cafe.photo)
            return
        }
        if let cafe = Constants.SelectedCafe.Index {
            let venueID = Constants.SearchedCafes.VenueIDs[cafe]
            FoursquareAPI.sharedInstance.getVenuePhotos(selectedVenueID: venueID) { sucess, errorString in
                if sucess {
                    guard let cafePhotoURL = Constants.Cafe.photoURLs.first else {
                        performUIUpdateOnMain {
                            self.noPhotosLabel.text = "No Photos Available"
                            self.photoLoadingIndicator.stopAnimating()
                        }
                        return
                    }
                    FoursquareAPI.sharedInstance.downloadImages(atImagePath: cafePhotoURL) { imageData in
                        if imageData != nil {
                            performUIUpdateOnMain {
                                self.photoLoadingIndicator.stopAnimating()
                                self.noPhotosLabel.isHidden = true
                                self.cafePhoto.image = UIImage(data: imageData!)
                            }
                        }
                        else {
                            performUIUpdateOnMain {
                                self.noPhotosLabel.text = "Loading Photos Failed!"
                                self.photoLoadingIndicator.stopAnimating()
                            }
                        }
                     Constants.Cafe.photo = imageData
                    }
                }
                else {
                    performUIUpdateOnMain {
                        self.noPhotosLabel.text = "Loading Photos Failed!"
                        self.photoLoadingIndicator.stopAnimating()
                        self.displayAnAlert(title: "Failed Loading Cafe Photos", message: errorString!)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCell
        if downloadedPhotos {
            cell.CellImage.image = UIImage(data: Photos[indexPath.row])
            return cell
        }
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageData = Photos[indexPath.row]
        cafePhoto.image = UIImage(data: imageData)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: Function configureCell(_ cell: PhotoCell, atIndexPath indexPath: IndexPath)
    func configureCell(_ cell: PhotoCell, atIndexPath indexPath: IndexPath) {
        let photoURL = Constants.Cafe.photoURLs[indexPath.row]
        let totalNumPhotos = Constants.Cafe.photoURLs.count
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: photoURL) { imageData in
            if imageData != nil {
                performUIUpdateOnMain {
                    cell.imageLoadingLabel.isHidden = true
                    cell.imageLoadingIndicator.stopAnimating()
                    cell.CellImage.image = UIImage(data: imageData!)
                }
                self.Photos.append(imageData!)
            }
            if self.Photos.count == totalNumPhotos {
                performUIUpdateOnMain {
                    self.completedDownloadingPhotos()
                }
            }
        }
    }
    
    // MARK: Function completedDownloadingPhotos()
    func completedDownloadingPhotos() {
        downloadedPhotos = true
        collectionView.reloadData()
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension CafePhotosViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Tells the size of a given cell in collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsects.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
}
