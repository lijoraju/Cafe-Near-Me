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
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageLoadingLabel: UILabel!
    @IBOutlet weak var cafePhoto: UIImageView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    
    var Photos: [Data] = []
    let itemsPerRow: CGFloat = 3
    let sectionInsects = UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.Cafe.photosData = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = Constants.Cafe.photoURLs {
            return photos.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCell
        cell.CellImage.image = #imageLiteral(resourceName: "CafeImagePlaceholder")
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageData = Photos[indexPath.row]
        cafePhoto.image = UIImage(data: imageData)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: Function configureCell
    func configureCell(_ cell: PhotoCell, atIndexPath indexPath: IndexPath) {
        let photoURL = Constants.Cafe.photoURLs[indexPath.row]
        let totalNumPhotos = Constants.Cafe.photoURLs.count - 1
        FoursquareAPI.sharedInstance.downloadImages(atImagePath: photoURL) { imageData in
            if imageData != nil {
                performUIUpdateOnMain {
                    cell.CellImage.image = UIImage(data: imageData!)
                }
                self.Photos.append(imageData!)
            }
            if indexPath.row == totalNumPhotos {
                performUIUpdateOnMain {
                    self.completedDownloading()
                }
            }
        }
    }
    
    // MARK: Function completedDownloading
    func completedDownloading() {
        cafePhoto.isHidden = false
        cafePhoto.image = UIImage(data: Constants.imageData)
        imageLoadingLabel.isHidden = true
        imageLoadingIndicator.stopAnimating()
        Constants.Cafe.photosData = Photos
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
