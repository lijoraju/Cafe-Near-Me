//
//  CoreData.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 16/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import CoreData

class CoreData {
    static let sharedInstance = CoreData()
    
    // MARK: Function gettingCafeInfo(managedObjectContext context: NSManagedObjectContext)-> Cafe
    func gettingCafeInfo(managedObjectContext context: NSManagedObjectContext)-> Cafe {
        let fetchRequest: NSFetchRequest<Cafe> = Cafe.fetchRequest()
        var cafes: [Cafe] = []
        do {
            cafes = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Unable to fetch \(error) \(error.userInfo)")
        }
        let cafeIndex = (Constants.SelectedCafe.Index)!
        let cafe = cafes[cafeIndex]
        return cafe
    }
    
    //MARK: Function checkCafeAleardyBookmarked(managedContext context: NSManagedObjectContext, venueID: String)-> Bool
    func checkCafeAleardyBookmarked(managedContext context: NSManagedObjectContext, venueID: String)-> Bool {
        let fetchRequest: NSFetchRequest<Cafe> = Cafe.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "venueID = %@", venueID)
        fetchRequest.predicate = predicate
        var cafe: [Cafe] = []
        do {
            cafe = try context.fetch(fetchRequest)
        }
        catch {
            return false
        }
        if cafe.count != 0 {
            return true
        }
        return false
    }
    
    // MARK: Function save(managedObjectContext context: NSManagedObjectContext, completionHandler: @escaping(_ sucess: Bool)-> void)
    func save(managedObjectContext context: NSManagedObjectContext, completionHandler: @escaping(_ sucess: Bool)-> Void) {
        do {
            try context.save()
            completionHandler(true)
        }
        catch let error as NSError {
            print("Error Occured:\(error) \(error.userInfo)")
            completionHandler(false)
        }
    }
    
}
