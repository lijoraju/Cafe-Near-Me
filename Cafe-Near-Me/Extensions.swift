//
//  Extensions.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 18/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import UIKit

// MARK: Extension UIViewController
extension UIViewController {
    
    // MARK: Function displayAnAlert(title: String, message: String)
    func  displayAnAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
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


