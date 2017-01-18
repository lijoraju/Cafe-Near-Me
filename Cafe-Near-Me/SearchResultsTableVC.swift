//
//  SearchResultsVC.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    let fetchRequest: NSFetchRequest<Cafe> = Cafe.fetchRequest()
    let managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cafes: [Cafe] = []
    var foursquareSearchFlag: Bool = false
    var editBookmarksMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(enable: false)
        let searchingLatLon = Constants.searchingLatLon
        if (searchingLatLon != nil) {
            let searchLocation = Constants.searchingLocation.capitalized
            title = "Cafes In " + searchLocation
            performFoursquareSearch()
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBookmarks))
            showingAllBookmarks()
        }
    }
    
    // MARK: Function performFoursquareSearch()
    func performFoursquareSearch() {
        foursquareSearchFlag = true
        if let LatLon = Constants.searchingLatLon {
            FoursquareAPI.sharedInstance.searchCafesForALocation(LatitudeAndLongitude: LatLon) { sucess, error in
                if sucess {
                    performUIUpdateOnMain {
                        self.configureUI(enable: true)
                        self.tableView.reloadData()
                    }
                }
                else {
                    performUIUpdateOnMain {
                        self.noResultsLabel.isHidden = false
                        self.noResultsLabel.text = "Sorry, No Cafes Found"
                        self.activityIndicator.stopAnimating()
                        self.displayAnAlert(title: "Searching Failed", message: error!)
                    }
                }
            }
        }
    }
    
    // MARK: Function showingAllBookmarks()
    func showingAllBookmarks() {
        do {
            cafes = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Failed showing bookmaks \(error) \(error.userInfo)")
        }
        if cafes.count == 0 {
            performUIUpdateOnMain {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteBookmarks))
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.tableView.isHidden = true
                self.noResultsLabel.isHidden = false
                self.noResultsLabel.text = "No Cafes Bookmarked"
                self.activityIndicator.stopAnimating()
            }
        }
        else {
            performUIUpdateOnMain {
                self.configureUI(enable: true)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foursquareSearchFlag {
            if let searchResults = Constants.SearchedCafes.Names {
                return searchResults.count
            }
        }
        return cafes.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let index = "\(indexPath.row + 1).  "
        if foursquareSearchFlag {
            cell.textLabel?.text = index + Constants.SearchedCafes.Names[indexPath.row]
            cell.detailTextLabel?.text = Constants.SearchedCafes.Addresses[indexPath.row]
            return cell
        }
        let cafe = cafes[indexPath.row]
        cell.textLabel?.text = index + cafe.name!
        cell.detailTextLabel?.text = cafe.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if foursquareSearchFlag {
            Constants.SelectedCafe.Index = indexPath.row
            Constants.Cafe.photo = nil
            Constants.Cafe.reviews = nil
            Constants.Cafe.reviewerNames = nil
            Constants.Cafe.reviewerPhotoURLs = nil
            Constants.Cafe.reviewerPhotos = nil
            Constants.Cafe.photoURLs = nil
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "TableViewToTabView", sender: self)
        }
        else {
            if editBookmarksMode {
                removeSeletedCafeFromBookmarks(cafeAtIndex: indexPath.row)
            }
            else {
                Constants.SelectedCafe.Index = indexPath.row
                tableView.deselectRow(at: indexPath, animated: true)
                performSegue(withIdentifier: "TableViewToTabView", sender: self)
            }
        }
    }
    
    // MARK: Function removeSeletedCafeFromBookmarks()
    func removeSeletedCafeFromBookmarks(cafeAtIndex index: Int) {
        let cafe = cafes[index]
        managedContext.delete(cafe)
        CoreData.sharedInstance.save(managedObjectContext: managedContext) { sucess in
            if sucess {
                print("Cafe removed from bookmarks")
                self.showingAllBookmarks()
            }
        }
    }
    
    // MARK: Function configureUI(enable: Bool)
    func configureUI(enable: Bool) {
        if enable {
            tableView.isHidden = false
            noResultsLabel.isHidden = true
            activityIndicator.stopAnimating()
        }
        else {
            tableView.isHidden = true
            noResultsLabel.isHidden = false
            noResultsLabel.text = "Searching..."
            activityIndicator.startAnimating()
        }
    }

    // MARK: Cancel button action
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        Constants.searchingLatLon = nil
    }
    
    // MARK: Function deleteBookmarks()
    func deleteBookmarks() {
        if editBookmarksMode {
            editBookmarksMode = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBookmarks))
        }
        else {
            editBookmarksMode = true
            displayAnAlert(title: "Warning: Deleting A Bookmark!", message: "Selecting a cafe will remove from bookmarks")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteBookmarks))
        }
    }
    
}
